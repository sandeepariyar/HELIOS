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
    if (ready) {
      await page.waitForFunction(() => {
        const s = document.querySelector('#screen');
        return s && getComputedStyle(s).display !== 'none';
      }, null, { timeout: 15000 }).catch(error => {
        errors.push('Qt loaded, but the QML display was not revealed: ' + error.message);
      });
    }
    // Qt creates the WebAssembly window asynchronously after onLoaded.
    // Wait for the actual canvas rather than checking on the same event tick.
    await page.waitForSelector('canvas', { state: 'attached', timeout: 15000 })
      .catch(error => errors.push('Qt canvas never attached: ' + error.message));
    await page.waitForTimeout(650);
    const viewportCheck = await page.evaluate(() => {
      const canvas = document.querySelector('canvas');
      const screen = document.querySelector('#screen');
      const spinner = document.querySelector('#qtspinner');
      const rect = screen?.getBoundingClientRect();
      return {
        canvasPresent: !!canvas,
        screenVisible: !!screen && getComputedStyle(screen).display !== 'none',
        spinnerHidden: !!spinner && getComputedStyle(spinner).display === 'none',
        shownWidth: Math.round(rect?.width || 0),
        shownHeight: Math.round(rect?.height || 0),
        hardwareLoaded: !!document.querySelector('#hardware')?.naturalWidth,
        hardwareVisible: !!document.querySelector('#hardware') &&
          getComputedStyle(document.querySelector('#hardware')).display !== 'none',
        stageCenterError: (() => {
          const d = document.querySelector('#device')?.getBoundingClientRect();
          return d ? Math.max(Math.abs(d.x + d.width / 2 - innerWidth / 2),
                              Math.abs(d.y + d.height / 2 - innerHeight / 2)) : 999;
        })()
      };
    });
    // Qt WebAssembly may attach its canvas through a shadow root.
    // Playwright locators pierce open shadow DOM; document.querySelector does not.
    viewportCheck.canvasPresent = (await page.locator('canvas').count()) > 0;
    if (!viewportCheck.canvasPresent || !viewportCheck.screenVisible ||
        !viewportCheck.spinnerHidden || viewportCheck.shownWidth < 600 ||
        !viewportCheck.hardwareLoaded || !viewportCheck.hardwareVisible ||
        viewportCheck.stageCenterError > 4) {
      errors.push('HELIOS viewport is not visibly displayed: ' + JSON.stringify(viewportCheck));
    }
    // Browser autoplay policies require a user click. Unlock the 3 original
    // WAV effects and verify a real QML mode button triggers C++ -> Web Audio.
    await page.locator('#audioToggle').click();
    await page.waitForFunction(() => window.heliosAudio?.enabled === true &&
      window.heliosAudio?.buffers?.length === 3, null, {timeout: 10000})
      .catch(error => errors.push('Web Audio failed to unlock/load: ' + error.message));
    const soundBefore = await page.evaluate(() => window.heliosAudio?.playCalls || 0);
    const qmlClick = await page.evaluate(() => {
      const screen = document.querySelector('#screen').getBoundingClientRect();
      const scale = screen.width / 840;
      return { x: screen.left + 455 * scale, y: screen.top + 43 * scale };
    });
    await page.mouse.click(qmlClick.x, qmlClick.y);
    await page.waitForTimeout(400);
    const soundAfter = await page.evaluate(() => window.heliosAudio?.playCalls || 0);
    console.log('HELIOS audio test:', JSON.stringify({soundBefore, soundAfter}));
    if (soundAfter <= soundBefore) errors.push('Qt QML click did not invoke the Web Audio bridge');
    await page.screenshot({ path: 'wasm-smoke.png', fullPage: true }).catch(() => {});
    console.log('HELIOS smoke result:', JSON.stringify({ ready, exited, viewportCheck, errors: errors.slice(-30), title: await page.title(), canvasCount: await page.locator('canvas').count() }));
    if (!ready || exited || errors.some(x => x.includes('HELIOS_STARTUP_FAILED') || x.includes('HELIOS viewport') || x.includes('Web Audio') || x.includes('QML click'))) process.exitCode = 1;
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
