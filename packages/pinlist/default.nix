pkgs:
let src = (builtins.getFlake "github:42LoCo42/pinlist/35f801f31d0fc3e5844cfcc14465b939e740866b"); in
src.packages.${pkgs.stdenv.hostPlatform.system}.default
