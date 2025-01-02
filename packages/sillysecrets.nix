pkgs:
let src = builtins.getFlake "github:42loco42/sillysecrets/38606ed36836f4c277cb3a2f539237b3d35f6b97"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "A very silly secrets manager";
    homepage = "https://github.com/42LoCo42/sillysecrets";
  };
})
