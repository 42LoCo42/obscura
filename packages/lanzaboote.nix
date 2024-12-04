pkgs:
let src = builtins.getFlake "github:nix-community/lanzaboote/b627ccd97d0159214cee5c7db1412b75e4be6086"; in
(pkgs.linkFarmFromDrvs "lanzaboote" (with src.packages.${pkgs.system}; [ stub tool ])).overrideAttrs {
  version = "0.4.1";
  meta = {
    description = "Secure Boot for NixOS";
    homepage = "https://github.com/nix-community/lanzaboote";
  };
}
