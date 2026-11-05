#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QSettings>
#include <QStringList>
#include <QTimer>
#include <QDateTime>
#include <cmath>
#ifdef HELIOS_HAS_MULTIMEDIA
#include <QSoundEffect>
#endif

// HELIOS is a simulator. Open-Meteo provides only weather observations/forecasts;
// NO hardware telemetry, contactor control or CAN bus is implied.
class EnergyBackend : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString mode READ mode NOTIFY changed)
    Q_PROPERTY(double solarKW READ solarKW NOTIFY changed)
    Q_PROPERTY(double loadKW READ loadKW NOTIFY changed)
    Q_PROPERTY(double surplusKW READ surplusKW NOTIFY changed)
    Q_PROPERTY(double gridKW READ gridKW NOTIFY changed)
    Q_PROPERTY(double batteryKW READ batteryKW NOTIFY changed)
    Q_PROPERTY(double soc READ soc NOTIFY changed)
    Q_PROPERTY(double availableKWh READ availableKWh NOTIFY changed)
    Q_PROPERTY(double busVoltage READ busVoltage NOTIFY changed)
    Q_PROPERTY(double temperature READ temperature NOTIFY changed)
    Q_PROPERTY(double currentAmps READ currentAmps NOTIFY changed)
    Q_PROPERTY(double efficiency READ efficiency NOTIFY changed)
    Q_PROPERTY(bool boost READ boost NOTIFY changed)
    Q_PROPERTY(bool island READ island NOTIFY changed)
    Q_PROPERTY(bool evCharge READ evCharge NOTIFY changed)
    Q_PROPERTY(bool isolated READ isolated NOTIFY changed)
    Q_PROPERTY(bool loadShed READ loadShed NOTIFY changed)
    Q_PROPERTY(bool weatherReady READ weatherReady NOTIFY changed)
    Q_PROPERTY(bool weatherSolar READ weatherSolar NOTIFY changed)
    Q_PROPERTY(QString weatherStatus READ weatherStatus NOTIFY changed)
    Q_PROPERTY(QString weatherUpdated READ weatherUpdated NOTIFY changed)
    Q_PROPERTY(double outsideC READ outsideC NOTIFY changed)
    Q_PROPERTY(double windKmh READ windKmh NOTIFY changed)
    Q_PROPERTY(double cloudCover READ cloudCover NOTIFY changed)
    Q_PROPERTY(double irradiance READ irradiance NOTIFY changed)
    Q_PROPERTY(QString location READ location NOTIFY changed)
    Q_PROPERTY(bool soundEnabled READ soundEnabled NOTIFY changed)
    Q_PROPERTY(int soundVolume READ soundVolume NOTIFY changed)
    Q_PROPERTY(double loadSetpoint READ loadSetpoint NOTIFY changed)
    Q_PROPERTY(int simulationSpeed READ simulationSpeed NOTIFY changed)
    Q_PROPERTY(double solarAvailability READ solarAvailability NOTIFY changed)
    Q_PROPERTY(QString alarm READ alarm NOTIFY changed)
    Q_PROPERTY(QStringList events READ events NOTIFY changed)
    Q_PROPERTY(int alarmCount READ alarmCount NOTIFY changed)
    Q_PROPERTY(QString timeToFull READ timeToFull NOTIFY changed)
    Q_PROPERTY(QString flowDirection READ flowDirection NOTIFY changed)
    Q_PROPERTY(bool networkBusy READ networkBusy NOTIFY changed)
    Q_PROPERTY(int assetCount READ assetCount CONSTANT)
    Q_PROPERTY(qint64 assetSourceBytes READ assetSourceBytes CONSTANT)
    Q_PROPERTY(qint64 executableBytes READ executableBytes CONSTANT)
    Q_PROPERTY(qint64 releaseZipBytes READ releaseZipBytes CONSTANT)
public:
    explicit EnergyBackend(QObject *parent=nullptr);
    QString mode() const {return m_mode;}
    double solarKW() const {return m_solar;}
    double loadKW() const {return m_load;}
    double surplusKW() const {return m_solar - m_load;}
    double gridKW() const {return m_grid;}
    double batteryKW() const {return m_battery;}
    double soc() const {return m_soc;}
    double availableKWh() const {return m_soc*0.288;}
    double busVoltage() const {return m_isolated ? 0.0 : 400.0 + 12.6*std::sin(m_phase);}
    double temperature() const {return 23.1 + 0.3*std::abs(m_battery);}
    double currentAmps() const {return std::abs(m_battery)*1000.0/53.2;}
    double efficiency() const {return m_isolated ? 0.0 : (m_boost ? 97.8 : 98.6);}
    bool boost() const {return m_boost;}
    bool island() const {return m_island;}
    bool evCharge() const {return m_evCharge;}
    bool isolated() const {return m_isolated;}
    bool loadShed() const {return m_loadShed;}
    bool weatherReady() const {return m_weatherReady;}
    bool weatherSolar() const {return m_weatherSolar;}
    QString weatherStatus() const {return m_weatherStatus;}
    QString weatherUpdated() const {return m_weatherUpdated;}
    double outsideC() const {return m_outsideC;}
    double windKmh() const {return m_windKmh;}
    double cloudCover() const {return m_cloudCover;}
    double irradiance() const {return m_irradiance;}
    QString location() const {return m_location;}
    bool soundEnabled() const {return m_soundEnabled;}
    int soundVolume() const {return m_soundVolume;}
    double loadSetpoint() const {return m_loadSetpoint;}
    int simulationSpeed() const {return m_speed;}
    double solarAvailability() const {return m_solarAvailability;}
    QString alarm() const {return m_alarm;}
    QStringList events() const {return m_events;}
    int alarmCount() const {return (m_isolated?1:0) + (m_loadShed?1:0) + (m_soc<15?1:0);}
    QString timeToFull() const;
    QString flowDirection() const;
    bool networkBusy() const {return m_networkBusy;}
    int assetCount() const;
    qint64 assetSourceBytes() const;
    qint64 executableBytes() const;
    qint64 releaseZipBytes() const;
    Q_INVOKABLE void selectMode(const QString &mode);
    Q_INVOKABLE void setActuator(const QString &key, bool enabled);
    Q_INVOKABLE void setLoadSetpoint(double kW);
    Q_INVOKABLE void setSoc(double percent);
    Q_INVOKABLE void setSolarAvailability(double percent);
    Q_INVOKABLE void setSimulationSpeed(int speed);
    Q_INVOKABLE void setWeatherSolar(bool enabled);
    Q_INVOKABLE void setSoundEnabled(bool enabled);
    Q_INVOKABLE void setSoundVolume(int percent);
    Q_INVOKABLE void emergencyTrip();
    Q_INVOKABLE void resetTrip();
    Q_INVOKABLE void refreshWeather();
    Q_INVOKABLE void setLocation(const QString &key);
    Q_INVOKABLE void acknowledgeAlarm();
    Q_INVOKABLE void resetDemo();
    Q_INVOKABLE double cellVoltage(int cell) const;
    Q_INVOKABLE void playTap();
signals:
    void changed();
private:
    void tick();
    void recalc();
    void log(const QString &line);
    void updateAlarm();
    void playSound(int kind);
    void storeSettings();
    QNetworkAccessManager m_network;
    QSettings m_settings{"HeliosPortfolio", "HeliosSimulator"};
    QTimer m_timer;
    QTimer m_weatherTimer;
    QString m_mode="balanced", m_location="Svalbard";
    QString m_weatherStatus="OFFLINE / SIMULATED", m_weatherUpdated="Never";
    QString m_alarm, m_lastAlarm;
    QStringList m_events;
    double m_solar=6.24, m_load=1.44, m_grid=0, m_battery=0, m_soc=78;
    double m_outsideC=0, m_windKmh=0, m_cloudCover=0, m_irradiance=0;
    double m_loadSetpoint=1.44, m_solarAvailability=88.0, m_phase=0;
    int m_speed=1, m_soundVolume=35;
    bool m_boost=false,m_island=true,m_evCharge=false,m_isolated=false,m_loadShed=false;
    bool m_weatherReady=false,m_weatherSolar=false,m_networkBusy=false,m_soundEnabled=true;
#ifdef HELIOS_HAS_MULTIMEDIA
    QSoundEffect m_confirm, m_warning, m_trip;
#endif
};
