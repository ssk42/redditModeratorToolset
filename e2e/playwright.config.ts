import { defineConfig, devices } from '@playwright/test';

const storageState = process.env.STORAGE_STATE && process.env.STORAGE_STATE.length > 0
  ? process.env.STORAGE_STATE
  : undefined;

export default defineConfig({
  testDir: './tests',
  timeout: 30_000,
  use: {
    baseURL: 'https://www.reddit.com',
    ignoreHTTPSErrors: true,
    trace: 'on-first-retry',
    storageState,
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
});

