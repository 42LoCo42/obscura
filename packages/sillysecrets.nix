pkgs:
let src = builtins.getFlake "github:42loco42/sillysecrets/5363f2a51d5fdfc6e948b0df704349c20d9968a8"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "The silliest secret manager! :3";
    homepage = "https://github.com/42LoCo42/sillysecrets";
  };
})
