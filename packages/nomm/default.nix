pkgs:
let
  inherit (pkgs.lib) makeLibraryPath;

  gradle = pkgs.gradle_9;

  ldpath = makeLibraryPath (with pkgs; [
    libGL
  ]);

  rpath = makeLibraryPath (with pkgs; [
    fontconfig
    libGL
    libgcc.lib
    libx11
  ]);
in
pkgs.stdenv.mkDerivation (drv: {
  pname = "nomm";
  version = "5.6.0";

  src = pkgs.fetchFromGitHub {
    owner = "Combat787";
    repo = drv.pname;
    tag = drv.version;
    hash = "sha256-I1aa6WiJbcxYreHfmYahAW2Xx72JOXaVJ76g8QjISTM=";
  };

  nativeBuildInputs = with pkgs; [
    gradle
    jetbrains.jdk-no-jcef
    makeBinaryWrapper
  ];

  gradleBuildTask = "createReleaseDistributable";

  gradleUpdateScript = ''
    gradle ${drv.gradleBuildTask} --write-verification-metadata sha256
  '';

  mitmCache = gradle.fetchDeps {
    pkg = drv.finalPackage;
    data = ./deps.json;
  };

  installPhase = ''
    cp -r composeApp/build/compose/binaries/main-release/app/NOMM $out

    wrapProgram $out/bin/NOMM \
      --prefix LD_LIBRARY_PATH : ${ldpath}

    mv $out/lib/app/{NOMM,.NOMM-wrapped}.cfg

    patchelf $out/lib/app/libskiko-linux-*.so \
      --add-rpath ${rpath}

    rm -rf $out/lib/runtime
    ln -s ${pkgs.temurin-jre-bin-25} $out/lib/runtime
  '';

  meta = {
    description = "A Mod Manager for the Game Nuclear Option";
    homepage = "https://github.com/Combat787/NOMM";
    mainProgram = "NOMM";
    broken = pkgs.stdenv.hostPlatform.isAarch64; # cba + it's only for mel
  };
})
