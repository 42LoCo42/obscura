pkgs:
let src = builtins.getFlake "github:42loco42/sillysecrets/d0e9b35c228890f0bccd2c5a0cd685516725916e"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "The silliest secret manager! :3";
    homepage = "https://github.com/42LoCo42/sillysecrets";
  };
})
