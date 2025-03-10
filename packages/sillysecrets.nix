pkgs:
let src = builtins.getFlake "github:42loco42/sillysecrets/8038bd7d6610bb4599b3183fb0f224a80eac8e3b"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "The silliest secret manager! :3";
    homepage = "https://github.com/42LoCo42/sillysecrets";
  };
})
