// @ts-check
import { defineConfig } from 'astro/config';

import react from '@astrojs/react';

import vercelAdapter from '@astrojs/vercel';

// https://astro.build/config
export default defineConfig({
  integrations: [react()],
  output: 'server',
  adapter: vercelAdapter()
});