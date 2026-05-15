# Tindahan Natin Landing Page

This is the official landing page for Tindahan Natin, built with Astro and React. It provides product information, legal documents, and an authenticated account deletion flow.

## 🚀 Project Structure

- `src/pages/`: Contains the routes (Index, Privacy, Terms, Delete My Account).
- `src/components/`: Reusable UI components (Hero, Features, etc.).
- `src/layouts/`: Shared page layouts.
- `auth.config.mjs`: Auth0 authentication configuration.

## 🧞 Commands

| Command | Action |
| :--- | :--- |
| `npm install` | Installs dependencies |
| `npm run dev` | Starts local dev server at `localhost:4321` |
| `npm run build` | Build your production site to `./dist/` |
| `npm run preview` | Preview your build locally |

## 🔐 Environment Variables

The landing page expects the following variables (automatically injected by the Aspire AppHost during local development):

- `AUTH_CLIENT_ID`: Auth0 Regular Web App Client ID.
- `AUTH_CLIENT_SECRET`: Auth0 Regular Web App Client Secret.
- `AUTH_ISSUER`: Auth0 Domain URL (with trailing slash).
- `AUTH_AUDIENCE`: Auth0 API Audience.
- `AUTH_SECRET`: A secret key for session encryption.
- `AUTH_TRUST_HOST`: Set to `true` for distributed environments.

## 🛠 Features

- **Responsive Design**: Modern, glassmorphism-inspired UI.
- **Authentication**: Integrated with Auth0 for secure user actions.
- **Account Deletion**: Self-service permanent account and data removal via authenticated API calls to the backend.
- **Legal Compliance**: Technical Privacy Policy and Terms of Service.
