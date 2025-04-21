pkgs:
let src = builtins.getFlake "github:42loco42/sillysecrets/9c047ee9df3c4e0f78486b69dd42fdaa1531c950"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "The silliest secret manager! :3";
    homepage = "https://github.com/42LoCo42/sillysecrets";
  };
})
