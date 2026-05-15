import Auth0 from "@auth/core/providers/auth0";
import { defineConfig } from "auth-astro";

export default defineConfig({
    secret: process.env.AUTH_SECRET,
	providers: [
		Auth0({
			clientId: process.env.AUTH_CLIENT_ID,
			clientSecret: process.env.AUTH_CLIENT_SECRET,
			issuer: process.env.AUTH_ISSUER ? (() => {
				let url = process.env.AUTH_ISSUER.startsWith('http') ? process.env.AUTH_ISSUER : `https://${process.env.AUTH_ISSUER}`;
				return url.endsWith('/') ? url : `${url}/`;
			})() : undefined,
            authorization: { 
                params: { 
                    scope: "openid profile email", 
                    audience: process.env.AUTH_AUDIENCE 
                } 
            },
		}),
	],
    callbacks: {
        async jwt({ token, account }) {
            if (account) {
                token.accessToken = account.access_token;
            }
            return token;
        },
        async session({ session, token }) {
            session.accessToken = token.accessToken;
            return session;
        },
    },
});
