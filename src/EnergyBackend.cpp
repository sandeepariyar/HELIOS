#include "EnergyBackend.h"
#include <QJsonDocument>
#include <QCoreApplication>
#include <QFileInfo>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrlQuery>
#include <QTimer>
#include <QtMath>
#include <algorithm>
#include <cmath>
#ifdef Q_OS_WIN
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>
#endif

#ifndef HELIOS_PNG_COUNT
#define HELIOS_PNG_COUNT 0
#endif
#ifndef HELIOS_PNG_SOURCE_BYTES
#define HELIOS_PNG_SOURCE_BYTES 0
#endif
#ifndef HELIOS_RELEASE_ZIP_BYTES
#define HELIOS_RELEASE_ZIP_BYTES 0
#endif

int EnergyBackend::assetCount() const {return HELIOS_PNG_COUNT;}
qint64 EnergyBackend::assetSourceBytes() const {return HELIOS_PNG_SOURCE_BYTES;}
qint64 EnergyBackend::releaseZipBytes() const {return HELIOS_RELEASE_ZIP_BYTES;}
qint64 EnergyBackend::executableBytes() const {
    return QFileInfo(QCoreApplication::applicationFilePath()).size();
}

namespace { double clamp(double x,double a,double b){return std::clamp(x,a,b);} }
EnergyBackend::EnergyBackend(QObject *parent):QObject(parent) {
    m_soundEnabled=m_settings.value("soundEnabled",true).toBool();
    m_soundVolume=m_settings.value("soundVolume",35).toInt();
    m_location=m_settings.value("location","Svalbard").toString();
    m_weatherSolar=m_settings.value("weatherSolar",false).toBool();
#ifdef HELIOS_HAS_MULTIMEDIA
    m_confirm.setSource(QUrl(QStringLiteral("qrc:/sounds/confirm.wav")));
    m_warning.setSource(QUrl(QStringLiteral("qrc:/sounds/warning.wav")));
    m_trip.setSource(QUrl(QStringLiteral("qrc:/sounds/trip.wav")));
#endif
    log("Simulation started — NO hardware connected");
    log("Weather: Open-Meteo, non-commercial demonstration");
    connect(&m_timer,&QTimer::timeout,this,&EnergyBackend::tick);
    m_timer.start(1000);
    connect(&m_weatherTimer,&QTimer::timeout,this,&EnergyBackend::refreshWeather);
    m_weatherTimer.start(15*60*1000);
    recalc();
    QTimer::singleShot(1000,this,&EnergyBackend::refreshWeather);
}
void EnergyBackend::storeSettings(){
    m_settings.setValue("soundEnabled",m_soundEnabled);m_settings.setValue("soundVolume",m_soundVolume);
    m_settings.setValue("location",m_location);m_settings.setValue("weatherSolar",m_weatherSolar);
}
void EnergyBackend::log(const QString &line){
    m_events.prepend(QDateTime::currentDateTime().toString("HH:mm:ss")+"  "+line);
    while(m_events.size()>12)m_events.removeLast();
    emit changed();
}
void EnergyBackend::playSound(int kind){
    if(!m_soundEnabled)return;
#ifdef HELIOS_HAS_MULTIMEDIA
    QSoundEffect *s= kind==2?&m_trip:(kind==1?&m_warning:&m_confirm);
    s->setVolume(clamp(m_soundVolume/100.0,0.0,1.0));s->play();
#elif defined(Q_OS_WIN)
    MessageBeep(kind==2 ? MB_ICONHAND : (kind==1 ? MB_ICONEXCLAMATION : MB_OK));
#else
    Q_UNUSED(kind);
#endif
}
void EnergyBackend::playTap(){playSound(0);}
void EnergyBackend::selectMode(const QString &name){
    if(m_isolated)return;
    if(name!="eco" && name!="balanced" && name!="perf")return;
    if(m_mode==name)return;
    m_mode=name;
    m_loadSetpoint= name=="eco"?1.04:(name=="perf"?2.34:1.44);
    log("Mode: "+name.toUpper());playSound(0);recalc();
}
void EnergyBackend::setActuator(const QString &key,bool on){
    if(m_isolated)return;
    if(key=="boost")m_boost=on;
    else if(key=="island")m_island=on;
    else if(key=="ev")m_evCharge=on;
    else return;
    log(key.toUpper()+" "+(on?"ENGAGED":"STANDBY"));playSound(0);recalc();
}
void EnergyBackend::setLoadSetpoint(double val){m_loadSetpoint=clamp(val,0.25,4.5);recalc();}
void EnergyBackend::setSoc(double val){m_soc=clamp(val,5,100);recalc();}
void EnergyBackend::setSolarAvailability(double val){m_solarAvailability=clamp(val,0,100);recalc();}
void EnergyBackend::setSimulationSpeed(int speed){m_speed=std::clamp(speed,1,600);emit changed();}
void EnergyBackend::setWeatherSolar(bool on){m_weatherSolar=on;storeSettings();log(on?"Solar model: WEATHER-DRIVEN ESTIMATE":"Solar model: MANUAL DEMO");recalc();}
void EnergyBackend::setSoundEnabled(bool on){m_soundEnabled=on;storeSettings();emit changed();if(on)playSound(0);}
void EnergyBackend::setSoundVolume(int val){m_soundVolume=std::clamp(val,0,100);storeSettings();emit changed();}
void EnergyBackend::emergencyTrip(){
    if(m_isolated)return;
    m_isolated=true;m_boost=false;m_evCharge=false;m_island=true;
    log("EMERGENCY: all simulated generation/contactors isolated");playSound(2);recalc();
}
void EnergyBackend::resetTrip(){
    if(!m_isolated)return;
    m_isolated=false;log("Simulated isolation reset by operator");playSound(0);recalc();
}
void EnergyBackend::acknowledgeAlarm(){log("Alarm acknowledged (does not clear underlying condition)");playSound(0);}
void EnergyBackend::resetDemo(){
    m_isolated=false;m_mode="balanced";m_boost=false;m_island=true;m_evCharge=false;
    m_soc=78;m_loadSetpoint=1.44;m_solarAvailability=88;m_speed=1;
    log("Demo values reset");recalc();playSound(0);
}
void EnergyBackend::setLocation(const QString &where){
    if(where!="Svalbard"&&where!="Oulu"&&where!="Helsinki")return;
    m_location=where;m_weatherReady=false;m_weatherStatus="REFRESHING";storeSettings();
    log("Weather site: "+where);refreshWeather();emit changed();
}
void EnergyBackend::refreshWeather(){
    if(m_networkBusy)return;
    m_networkBusy=true;m_weatherStatus="FETCHING OPEN-METEO";emit changed();
    double lat=78.2232,lon=15.6469;
    if(m_location=="Oulu"){lat=65.0121;lon=25.4651;}
    if(m_location=="Helsinki"){lat=60.1699;lon=24.9384;}
    QUrl url("https://api.open-meteo.com/v1/forecast");
    QUrlQuery query;
    query.addQueryItem("latitude",QString::number(lat,'f',4));
    query.addQueryItem("longitude",QString::number(lon,'f',4));
    query.addQueryItem("current","temperature_2m,wind_speed_10m,cloud_cover,shortwave_radiation,is_day");
    query.addQueryItem("timezone","UTC");
    url.setQuery(query);
    QNetworkRequest request(url);
#ifndef Q_OS_WASM
    request.setRawHeader("User-Agent","HELIOS-Qt6-Portfolio/0.3 (Open-Meteo weather demo)");
#endif
    QNetworkReply *reply=m_network.get(request);
    auto *timeout=new QTimer(reply);timeout->setSingleShot(true);
    connect(timeout,&QTimer::timeout,reply,[reply](){ if(reply->isRunning())reply->abort();});
    timeout->start(10000);
    connect(reply,&QNetworkReply::finished,this,[this,reply](){
        m_networkBusy=false;
        bool valid=false;
        if(reply->error()==QNetworkReply::NoError){
            const auto parsed=QJsonDocument::fromJson(reply->readAll());
            const auto current=parsed.object().value("current").toObject();
            if(current.contains("shortwave_radiation")&&current.contains("temperature_2m")){
                m_outsideC=current.value("temperature_2m").toDouble();
                m_windKmh=current.value("wind_speed_10m").toDouble();
                m_cloudCover=current.value("cloud_cover").toDouble();
                m_irradiance=std::max(0.0,current.value("shortwave_radiation").toDouble());
                m_weatherUpdated=QDateTime::currentDateTimeUtc().toString("HH:mm 'UTC'");
                m_weatherReady=true;m_weatherStatus="LIVE WEATHER / SIMULATED ENERGY";valid=true;
            }
        }
        if(!valid){m_weatherReady=false;m_weatherStatus="OFFLINE / SIMULATED ENERGY";}
        reply->deleteLater();
        recalc();
    });
}
void EnergyBackend::tick(){
    m_phase+=0.07;
    recalc();
    m_soc=clamp(m_soc + m_battery*m_speed/(28.8*36.0),5,100); // kW * seconds / 3600 / capacity * 100
    recalc();
}
void EnergyBackend::updateAlarm(){
    QString a;
    if(m_isolated)a="EMERGENCY ISOLATION — SIMULATION TRIPPED";
    else if(m_loadShed)a="POWER DEFICIT — LOAD SHEDDING";
    else if(m_soc<15)a="LOW BATTERY — RESERVE BELOW 15%";
    m_alarm=a;
    if(a!=m_lastAlarm){
        if(!a.isEmpty()){log("ALARM: "+a);playSound(1);}
        else if(!m_lastAlarm.isEmpty())log("Active alarm condition cleared");
        m_lastAlarm=a;
    }
}
void EnergyBackend::recalc(){
    if(m_isolated){m_solar=0;m_load=0;m_grid=0;m_battery=0;m_loadShed=false;updateAlarm();emit changed();return;}
    const double ratedSolarKW=7.1;
    // Manual reference defaults close to the Figma concept (6.24 kW solar) and never claims to be live hardware.
    m_solar=m_weatherSolar && m_weatherReady
        ? ratedSolarKW*clamp(m_irradiance/1000.0,0.0,1.25)*0.88
        : ratedSolarKW*m_solarAvailability/100.0;
    m_solar*=m_boost?1.035:1.0;
    m_load=m_loadSetpoint+(m_evCharge?1.25:0.0);
    const double net=m_solar-m_load;
    const double chargeLimit=m_boost?4.5:3.6;
    const double dischargeLimit=3.6;
    if(net>=0)m_battery=m_soc>=99.9?0:std::min(net,chargeLimit);
    else m_battery=m_soc<=5.1?0:-std::min(-net,dischargeLimit);
    const double residual=net-m_battery;
    m_grid=m_island?0:-residual; // + import / - export
    m_loadShed=m_island && residual < -0.03;
    updateAlarm();
    emit changed();
}
QString EnergyBackend::timeToFull() const {
    if(m_isolated)return "ISOLATED";
    if(m_battery<=0.02)return "NOT CHARGING";
    const double hrs=(28.8-availableKWh())/m_battery;
    return QString("%1h %2m").arg((int)hrs).arg(((int)(hrs*60))%60,2,10,QChar('0'));
}
QString EnergyBackend::flowDirection() const {
    if(m_isolated)return "ISOLATED";
    if(m_loadShed)return "LOAD SHEDDING";
    if(m_battery>0.02)return "SURPLUS TO STORAGE";
    if(m_battery< -0.02)return "BATTERY TO LOAD";
    return m_grid < -0.01?"EXPORTING TO GRID":(m_grid > 0.01?"IMPORTING FROM GRID":"BALANCED");
}
double EnergyBackend::cellVoltage(int index)const{
    if(index<0||index>=16)return 0;
    return 3.02+m_soc*0.0033+0.003*std::sin(index*2.5+m_phase);
}
