import { defineConfig } from "vite";

export default defineConfig({
	server: {
		watch: {
			ignored: [
				"**/.direnv/**",
				"**/result/**"
			],
		},
	},
});
