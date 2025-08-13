import { test, expect } from '@playwright/test';

test.describe('Reddit modmail (authenticated, using storage state)', () => {
  test.skip(({ baseURL }) => !process.env.STORAGE_STATE, 'Requires STORAGE_STATE');
  test.setTimeout(60_000);

  test('navigates to modmail inbox', async ({ page }) => {
    await page.goto('/mod/mail/inbox', { waitUntil: 'domcontentloaded' });
    if (page.url().includes('/login')) {
      test.skip(true, 'Storage state invalid or expired (redirected to /login).');
    }
    await expect(page).toHaveURL(/\/mod\/mail/);

    const bodyContent = await page.textContent('body');
    expect(bodyContent?.length ?? 0).toBeGreaterThan(0);
  });
});

