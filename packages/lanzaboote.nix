pkgs:
let src = builtins.getFlake "github:nix-community/lanzaboote/a65905a09e2c43ff63be8c0e86a93712361f871e"; in
(pkgs.linkFarmFromDrvs "lanzaboote" (with src.packages.${pkgs.system}; [ stub tool ])).overrideAttrs {
  version = "0.4.2";
  meta = {
    description = "Secure Boot for NixOS";
    homepage = "https://github.com/nix-community/lanzaboote";
  };
}
