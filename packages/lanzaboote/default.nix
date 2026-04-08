pkgs:
let
  src = import (import ./source.nix) {
    inherit (pkgs.stdenv) system;
  };

  lanza = src.packages;
in
pkgs.symlinkJoin rec {
  inherit (lanza.lzbt) pname version;

  paths = with lanza; [ lzbt stub ];

  passthru = { inherit (lanza) lzbt stub; };

  meta = {
    description = "Secure Boot for NixOS";
    homepage = "https://github.com/nix-community/lanzaboote";
    mainProgram = pname;
  };
}
