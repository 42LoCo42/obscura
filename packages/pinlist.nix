pkgs:
let src = builtins.getFlake "github:42loco42/pinlist/4cb28595176e7c9b4a04192ee57641a41cd03b32"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "Super simple text/link pinlist tool";
    homepage = "https://github.com/42LoCo42/pinlist";
  };
})
