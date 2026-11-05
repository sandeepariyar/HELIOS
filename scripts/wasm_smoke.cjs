'use strict';
const { chromium } = require('playwright-core');

(async () => {
  const browserPath = process.env.CHROME_PATH || '/usr/bin/google-chrome';
  const browser = await chromium.launch({
    executablePath: browserPath,
    headless: true,
    args: ['--no-sandbox', '--disable-dev-shm-usage', '--enable-webgl', '--use-gl=angle', '--use-angle=swiftshader', '--disable-web-security']
  });
  const page = await browser.newPage({ viewport: { width: 1200, height: 800 } });
  let ready = false;
  let exited = false;
  const errors = [];
  page.on('console', message => {
    const line = message.text();
    if (line.includes('HELIOS_READY')) ready = true;
    if (line.includes('HELIOS_STARTUP_FAILED')) errors.push(line);
    if (message.type() === 'error') errors.push(line);
    console.log('[browser console ' + message.type() + '] ' + line);
  });
  page.on('pageerror', error => {
    errors.push(error.message);
    console.error('[browser pageerror]', error.stack || error.message);
  });
  page.on('requestfailed', request => console.error('[request failed]', request.url(), request.failure()?.errorText));
  page.on('response', response => {
    if (response.status() >= 400) console.error('[HTTP ' + response.status() + ']', response.url());
  });
  try {
    await page.goto('http://127.0.0.1:8765/', { waitUntil: 'domcontentloaded', timeout: 30000 });
    for (let attempt = 0; attempt < 120; ++attempt) {
      if (ready) break;
      const text = await page.locator('body').innerText().catch(() => '');
      if (/Application exit\s*\(/i.test(text)) {
        exited = true;
        break;
      }
      await page.waitForTimeout(1000);
    }
    await page.waitForFunction(() => {
      const f = document.querySelector('#qtFrame');
      const s = document.querySelector('#qtspinner');
      return f && getComputedStyle(f).opacity === '1' &&
        s && getComputedStyle(s).display === 'none';
    }, null, {timeout: 20000})
      .catch(e => errors.push('Qt iframe not revealed: '+e.message));
    const qtCanvas = page.frameLocator('#qtFrame').locator('canvas').first();
    await qtCanvas.waitFor({state:'attached',timeout:15000})
      .catch(e => errors.push('Qt canvas missing inside iframe: '+e.message));
    await page.waitForTimeout(500);
    const viewportCheck = await page.evaluate(() => {
      const aperture = document.querySelector('#lcdViewport').getBoundingClientRect();
      const frame = document.querySelector('#qtFrame').getBoundingClientRect();
      const device = document.querySelector('#device').getBoundingClientRect();
      const hw = document.querySelector('#hardware');
      return {
        aperture: {x:aperture.x,y:aperture.y,w:aperture.width,h:aperture.height},
        frame: {x:frame.x,y:frame.y,w:frame.width,h:frame.height},
        screenVisible: getComputedStyle(document.querySelector('#qtFrame')).opacity === '1',
        spinnerHidden: getComputedStyle(document.querySelector('#qtspinner')).display === 'none',
        hardwareLoaded: hw.naturalWidth > 0,
        deviceCenterError: Math.max(Math.abs(device.x+device.width/2-innerWidth/2),
          Math.abs(device.y+device.height/2-innerHeight/2))
      };
    });
    const frameCanvasCount = await page.frameLocator('#qtFrame').locator('canvas').count();
    const canvasBounds = frameCanvasCount ? await qtCanvas.boundingBox() : null;
    viewportCheck.qtCanvasCount = frameCanvasCount;
    viewportCheck.canvasBounds = canvasBounds;
    const a=viewportCheck.aperture,f=viewportCheck.frame;
    const mapped = Math.abs(a.x-f.x)<2 && Math.abs(a.y-f.y)<2 &&
      Math.abs(a.w-f.w)<2 && Math.abs(a.h-f.h)<2;
    if (!mapped || !viewportCheck.qtCanvasCount || !viewportCheck.screenVisible ||
        !viewportCheck.spinnerHidden || !viewportCheck.hardwareLoaded ||
        viewportCheck.deviceCenterError > 4) {
      errors.push('HELIOS viewport is not visibly displayed: '+JSON.stringify(viewportCheck));
    }
    // Browser autoplay policies require a user click. Unlock the 3 original
    // WAV effects and verify a real QML mode button triggers C++ -> Web Audio.
    await page.locator('#audioToggle').click();
    await page.waitForFunction(() => window.heliosAudio?.enabled === true &&
      window.heliosAudio?.buffers?.length === 3, null, {timeout: 10000})
      .catch(error => errors.push('Web Audio failed to unlock/load: ' + error.message));
    const soundBefore = await page.evaluate(() => window.heliosAudio?.playCalls || 0);
    const qmlClick = await page.evaluate(() => {
      const nativeScreen = document.querySelector('#qtFrame').getBoundingClientRect();
      // Map the known ECO button at native 840x520 coordinates into
      // the aperture after browser and hardware-stage scaling.
      return {x:nativeScreen.x + 455 * nativeScreen.width / 840,
              y:nativeScreen.y + 43 * nativeScreen.height / 520};
    });
    await page.mouse.click(qmlClick.x, qmlClick.y);
    await page.waitForTimeout(400);
    const soundAfter = await page.evaluate(() => window.heliosAudio?.playCalls || 0);
    console.log('HELIOS audio test:', JSON.stringify({soundBefore, soundAfter}));
    if (soundAfter <= soundBefore) errors.push('Qt QML click did not invoke the Web Audio bridge');
    await page.screenshot({ path: 'wasm-smoke.png', fullPage: true }).catch(() => {});
    console.log('HELIOS smoke result:', JSON.stringify({ ready, exited, viewportCheck, errors: errors.slice(-30), title: await page.title(), canvasCount: frameCanvasCount }));
    if (!ready || exited || errors.some(x => x.includes('HELIOS_STARTUP_FAILED') || x.includes('HELIOS viewport') || x.includes('Web Audio') || x.includes('QML click'))) process.exitCode = 1;
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
