#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "EnergyBackend.h"

int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    app.setOrganizationName("HeliosPortfolio");
    app.setApplicationName("HeliosSimulator");
    EnergyBackend backend;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("backend", &backend);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []{QCoreApplication::exit(-1);}, Qt::QueuedConnection);
    engine.loadFromModule("Helios","Main");
    return app.exec();
}
