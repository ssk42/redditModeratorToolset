import { test, expect } from '@playwright/test';

test.describe('Reddit modqueue (authenticated, using storage state)', () => {
  test.setTimeout(60_000);
  test.skip(({ baseURL }) => !process.env.STORAGE_STATE, 'Requires STORAGE_STATE');

  test('navigates to moderator subs and attempts modqueue', async ({ page }) => {
    await page.goto('/subreddits/mine/moderator', { waitUntil: 'domcontentloaded' });
    if (page.url().includes('/login')) {
      test.skip(true, 'Storage state invalid or expired (redirected to /login).');
    }
    await expect(page).toHaveURL(/\/subreddits\/mine\/moderator/);

    // Navigate to modqueue (current Reddit path; fallback to legacy if needed)
    await page.goto('/mod/queue', { waitUntil: 'domcontentloaded' });
    const current = page.url();
    if (!/\/mod\/queue/.test(current)) {
      await page.goto('/r/mod/about/modqueue', { waitUntil: 'domcontentloaded' });
    }
    await expect(page).toHaveURL(/(\/mod\/queue|\/about\/modqueue)/);

    // Soft readiness check (no PII)
    const bodyContent = await page.textContent('body');
    expect(bodyContent?.length ?? 0).toBeGreaterThan(0);
  });
});

