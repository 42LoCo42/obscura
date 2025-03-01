pkgs:
let
  # edk2 version 202408.01
  pkgs-fixed = import
    (builtins.getFlake "github:nixos/nixpkgs/8edf06bea5bcbee082df1b7369ff973b91618b8d")
    { inherit (pkgs) system; };
in
pkgs.stdenv.mkDerivation rec {
  pname = "i915ovmfPkg";
  version = "1.0.0";

  srcs = [
    (pkgs.fetchFromGitHub {
      name = "main";

      owner = "x78x79x82x79";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-uTCyidJspWw/YopowIkLFmLTmP66FfV9zjaVPm1MNCQ=";
    })
    (pkgs.fetchFromGitHub rec {
      name = "edk2-platforms";

      owner = "tianocore";
      repo = name;
      rev = "6d4a02e40d7f1e6dbcb56a2f99dc42fc3ec7ac99";
      hash = "sha256-Pp5vprgJ4aDSAWiRON3Uin4XZLKTlYYrCvwbOp8m9a8=";
    })
  ];

  sourceRoot = "main";

  nativeBuildInputs = with pkgs; [
    nasm
    python3
    rsync
  ];

  postUnpack = ''
    rsync -a ${pkgs-fixed.edk2}/ ${pkgs-fixed.edk2.src}/ edk2/
  '';

  enableParallelBuilding = true;
  buildPhase = "bash build.sh";

  installPhase = ''
    source config
    ROM_FILE="i915ovmf.rom"
    cp "$WORKSPACE/Build/i915ovmf/''${BUILD_TYPE}_GCC5/X64/$ROM_FILE" $out
  '';

  meta = {
    description = "VBIOS for Intel GPU Passthrough";
    homepage = "https://github.com/x78x79x82x79/i915ovmfPkg";
  };
}
