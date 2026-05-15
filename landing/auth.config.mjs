import Auth0 from "@auth/core/providers/auth0";
import { defineConfig } from "auth-astro";

export default defineConfig({
	providers: [
		Auth0({
			clientId: import.meta.env.AUTH_CLIENT_ID,
			clientSecret: import.meta.env.AUTH_CLIENT_SECRET,
			issuer: import.meta.env.AUTH_ISSUER,
            authorization: { 
                params: { 
                    scope: "openid profile email", 
                    audience: import.meta.env.AUTH_AUDIENCE 
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
