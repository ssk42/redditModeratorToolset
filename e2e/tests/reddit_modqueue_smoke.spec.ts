import { test, expect } from '@playwright/test';

test.describe('Reddit modqueue smoke (public endpoints)', () => {
  test('modqueue landing pages load', async ({ page }) => {
    await page.goto('/subreddits/mine/moderator');
    await expect(page).toHaveTitle(/Reddit/);

    // We can't access private modqueue without auth, but we can verify nav loads
    await page.goto('/r/mod/about/modqueue');
    await expect(page).toHaveTitle(/Reddit/);
  });
});

