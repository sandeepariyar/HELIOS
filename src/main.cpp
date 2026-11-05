#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlError>
#include <QDebug>
#include <QUrl>
#include "EnergyBackend.h"

int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    app.setOrganizationName("HeliosPortfolio");
    app.setApplicationName("HeliosSimulator");
    EnergyBackend backend;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("backend", &backend);
    QObject::connect(&engine, &QQmlApplicationEngine::warnings,
                     &app, [](const QList<QQmlError> &warnings) {
        for (const auto &warning : warnings)
            qWarning().noquote() << "HELIOS_QML_WARNING:" << warning.toString();
    });
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [](QObject *object, const QUrl &url) {
        if (object)
            qInfo().noquote() << "HELIOS_READY: QML root loaded:" << url.toString();
        else
            qCritical().noquote() << "HELIOS_STARTUP_FAILED: QML root creation failed:" << url.toString();
    });
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, [] { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("Helios", "Main");
    return app.exec();
}
