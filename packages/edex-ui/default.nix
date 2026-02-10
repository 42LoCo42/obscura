pkgs:
let
  pname = "edex-ui";
  version = "2.2.8";

  sys = pkgs.stdenv.hostPlatform.linuxArch;

  img = pkgs.fetchurl {
    url = "https://github.com/GitSquared/edex-ui/releases/download/v${version}/eDEX-UI-Linux-${sys}.AppImage";
    hash = {
      "arm64" = "sha256-Gv4BRsMS3J/eHFae03DLzcgrpCgq43KnkhzW38lGIjY=";
      "x86_64" = "sha256-yPKM1yHKAyygwZYLdWyj5k3EQaZDwy6vu3nGc7QC1oE=";
    }.${sys};
  };

  run = pkgs.appimage-run.override {
    extraPkgs = p: with p; [
      libxshmfence
    ];
  };
in
(pkgs.writeShellApplication {
  name = pname;
  runtimeInputs = [ run ];
  text = "appimage-run ${img}";
}).overrideAttrs {
  inherit pname version;

  meta = {
    description = "A cross-platform, customizable science fiction terminal emulator";
    homepage = "https://github.com/GitSquared/edex-ui";
    mainProgram = pname;
  };
}
