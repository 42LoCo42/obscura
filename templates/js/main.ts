console.log("Hello, World!");

(async () => {
	const resp = await fetch("https://icanhazip.com");
	const body = await resp.text();
	console.log(body);
})();
