pkgs:
let src = builtins.getFlake "github:42loco42/sillysecrets/f41630b86abbd9a53828826bcec322290d190b92"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "A very silly secrets manager";
    homepage = "https://github.com/42LoCo42/sillysecrets";
  };
})
