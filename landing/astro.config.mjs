// @ts-check
import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import vercelAdapter from '@astrojs/vercel';
import auth from 'auth-astro';

// https://astro.build/config
export default defineConfig({
  integrations: [react(), auth()],
  output: 'server',
  adapter: vercelAdapter()
});