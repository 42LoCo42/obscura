pkgs:
let src = builtins.getFlake "github:42loco42/sillysecrets/4f7701a66a3a46343e342e47cdab76178dd604ec"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "The silliest secret manager! :3";
    homepage = "https://github.com/42LoCo42/sillysecrets";
  };
})
