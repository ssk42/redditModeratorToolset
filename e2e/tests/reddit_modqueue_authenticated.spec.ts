import { test, expect } from '@playwright/test';

test.describe('Reddit modqueue (authenticated, using storage state)', () => {
  test.skip(({ baseURL }) => !process.env.STORAGE_STATE, 'Requires STORAGE_STATE');

  test('navigates to moderator subs and attempts modqueue', async ({ page }) => {
    await page.goto('/subreddits/mine/moderator');
    await expect(page).toHaveTitle(/Reddit/);

    // Example navigation; exact selectors may vary by Reddit updates
    await page.goto('/r/mod/about/modqueue');
    await expect(page).toHaveTitle(/Reddit/);

    // Soft assertion that page content loads (without leaking any PII)
    // We intentionally avoid snapshotting content; we only check general page readiness
    const bodyContent = await page.textContent('body');
    expect(bodyContent?.length ?? 0).toBeGreaterThan(0);
  });
});

