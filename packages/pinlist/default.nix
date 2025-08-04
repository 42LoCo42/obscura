pkgs:
let src = (builtins.getFlake "github:42LoCo42/pinlist/78189b4f2ecc0091a7a133dbb8c3d025e7971cd4"); in
src.packages.${pkgs.system}.default
