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
        shownHeight: Math.round(rect?.height || 0)
      };
    });
    if (!viewportCheck.canvasPresent || !viewportCheck.screenVisible ||
        !viewportCheck.spinnerHidden || viewportCheck.shownWidth < 600) {
      errors.push('HELIOS viewport is not visibly displayed: ' + JSON.stringify(viewportCheck));
    }
    await page.screenshot({ path: 'wasm-smoke.png', fullPage: true }).catch(() => {});
    console.log('HELIOS smoke result:', JSON.stringify({ ready, exited, viewportCheck, errors: errors.slice(-30), title: await page.title(), canvasCount: await page.locator('canvas').count() }));
    if (!ready || exited || errors.some(x => x.includes('HELIOS_STARTUP_FAILED') || x.includes('HELIOS viewport'))) process.exitCode = 1;
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
