pkgs: pkgs.stdenv.mkDerivation (drv: {
  pname = "ceserver";
  version = "7.5-unstable-2025-04-19";

  src = pkgs.fetchFromGitHub {
    owner = "cheat-engine";
    repo = "cheat-engine";
    rev = "ec45d5f47f92a239ba0bf51ec5d04a7509c3fd37";
    hash = "sha256-wQ0LR8rbG1KVIk0Lg1Iokm8Nf2+D/4DgMCQXC854T5E=";
  };

  sourceRoot = "${drv.src.name}/Cheat Engine/ceserver";

  prePatch =
    let
      nowarn = pkgs.lib.join " " [
        "-Wno-implicit-function-declaration"
        "-Wno-incompatible-pointer-types"
        "-Wno-int-conversion"
      ];
    in
    ''
      sed -Ei 's|(CFLAGS *=)|\1 ${nowarn} |' gcc/makefile
    '';

  buildInputs = with pkgs; [ libz ];

  enableParallelBuilding = true;

  makeFlags = [ "-C gcc" ];

  installPhase = ''
    install -Dm755 {gcc,$out/bin}/${drv.pname}
  '';

  meta = {
    description = "Linux server for Cheat Engine";
    homepage = "https://github.com/cheat-engine/cheat-engine/blob/master/Cheat%20Engine/ceserver";
    mainProgram = drv.pname;
    broken = pkgs.stdenv.hostPlatform.isAarch64;
  };
})
