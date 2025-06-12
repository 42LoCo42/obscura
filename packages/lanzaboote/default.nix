pkgs:
let
  src = import ./source.nix;
  lanza = src.packages.${pkgs.system};
  module = "${src}/nix/modules/lanzaboote.nix";
in
pkgs.symlinkJoin rec {
  pname = lanza.tool.name;
  inherit (lanza.stub) version;

  paths = with lanza; [ stub tool ];

  passthru = {
    inherit module;
    inherit (lanza) stub tool;
  };

  meta = {
    description = "Secure Boot for NixOS";
    homepage = "https://github.com/42LoCo42/lanzaboote";
    mainProgram = pname;
  };
}
