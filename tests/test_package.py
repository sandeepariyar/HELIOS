"""Dependency-light preflight for a Qt6 project when Qt Creator is not available.
Run: python tests/test_package.py
These are SOURCE checks, not a Qt runtime test.
"""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
QML=(ROOT/'qml'/'Main.qml').read_text(encoding='utf-8')
ALL='\n'.join(x.read_text(encoding='utf-8') for x in (ROOT/'qml').glob('*.qml'))
CMAKE=(ROOT/'CMakeLists.txt').read_text(encoding='utf-8')
BACKEND=(ROOT/'src'/'EnergyBackend.cpp').read_text(encoding='utf-8')
HEADER=(ROOT/'src'/'EnergyBackend.h').read_text(encoding='utf-8')
PNG=list((ROOT/'assets').glob('*.png'))
refs=set(re.findall(r'assets/([A-Za-z0-9_.-]+\.png)', ALL))
assert refs, 'No optimized PNG files referenced'
assert len(refs)==len(PNG), f'Dead/duplicate assets: refs={len(refs)} stored={len(PNG)}'
assert not (refs - {x.name for x in PNG}), 'Some referenced assets are missing'
assert 'NO_CACHEGEN' in CMAKE and 'Qt6::Network' in CMAKE
assert 'visible: root.currentView === "assets"' not in QML
assert 'ASSET SHEET & ATLAS' not in QML
assert 'RASTER ASSET BUDGET' not in QML
assert all(x in QML for x in ('"main"','"topology"','"battery"'))
assert all(x in QML for x in ('backend.selectMode','backend.setActuator','backend.soc','backend.solarKW','backend.gridKW'))
assert all(x in QML for x in ('McuSlider {', 'McuRadialSlider {', 'backend.emergencyTrip()', 'backend.resetTrip()'))
for method in ('selectMode','setActuator','setLoadSetpoint','setSoc','setSolarAvailability','setSimulationSpeed','setWeatherSolar','setSoundEnabled','setSoundVolume','emergencyTrip','resetTrip','refreshWeather','setLocation','acknowledgeAlarm','resetDemo'):
    assert method+'(' in HEADER, f'{method} missing from C++ interface'
    assert method+'(' in BACKEND, f'{method} missing from implementation'
assert 'api.open-meteo.com' in BACKEND
assert all((ROOT/'sounds'/x).is_file() for x in ('confirm.wav','warning.wav','trip.wav'))
# Rough QML structural check: ignores quoted strings and checks braces.
def braces_balanced(text):
    level=0; inside=False;escaped=False
    for c in text:
        if inside:
            if escaped:escaped=False
            elif c=='\\':escaped=True
            elif c=='"':inside=False
        else:
            if c=='"':inside=True
            elif c=='{':level+=1
            elif c=='}':
                level-=1
                if level<0:return False
    return level==0 and not inside
assert all(braces_balanced(f.read_text(encoding='utf-8')) for f in (ROOT/'qml').glob('*.qml'))
print('PASS: QML structural/asset checks, no atlas UI, 3 screens, backend APIs, audio files, CMake settings')
print('Unique optimized PNGs:',len(PNG),'source bytes:',sum(x.stat().st_size for x in PNG))
print('NOTE: Qt SDK is needed for C++ compilation and real interaction tests.')

# v0.3 regression guards (source-level, not a runtime/Qt SDK validation)
RADIAL=(ROOT/'qml'/'McuRadialSlider.qml').read_text(encoding='utf-8')
DEV=(ROOT/'qml'/'DevMetricsPanel.qml').read_text(encoding='utf-8')
assert 'centerText: Math.round(backend.soc) + "%"' in QML
assert 'anchors.centerIn: parent' in RADIAL and 'text: root.centerText' in RADIAL
assert 'id: settingsScrim' in QML and 'opacity:0.82' in QML
assert 'DESIGNED & DEVELOPED BY SANDEEP PARIYAR' in QML
assert 'DevMetricsPanel {' in QML and 'MCU FRAMEBUFFER ESTIMATOR' in DEV
assert 'HELIOS_RELEASE_ZIP_BYTES' in CMAKE
assert len(PNG) == 60
print('PASS: v0.3 visual/layout/metrics regression checks')
