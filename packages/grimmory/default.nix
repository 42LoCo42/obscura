pkgs:
let
  pname = "grimmory";
  version = "3.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "grimmory-tools";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-qBccjV+0zT34WNTjucvGC+jR6WuZGfClEMyR8YUD0iU=";
  };

  yarn = pkgs.yarn-berry_4;

  frontend = pkgs.stdenv.mkDerivation (drv: {
    pname = "${pname}-frontend";
    inherit version src;
    sourceRoot = "${src.name}/frontend";

    patches = [
      ./yarn-4.14-support.patch
    ];

    nativeBuildInputs = with pkgs; [
      nodejs
      yarn
      yarn.yarnBerryConfigHook
    ];

    missingHashes = ./missing-hashes.json;

    offlineCache = yarn.fetchYarnBerryDeps {
      inherit (drv) src sourceRoot patches missingHashes;
      hash = "sha256-AAy5d9QnZWqCI9IPBMTEMNPRRef5gBYbBAAOsoMl7RI=";
    };

    buildPhase = ''
      yarn run build:prod
    '';

    installPhase = ''
      cp -r dist/grimmory/browser $out
    '';
  });

  backend = pkgs.stdenv.mkDerivation (drv: {
    pname = "${pname}-backend";
    inherit version src;
    sourceRoot = "${src.name}/backend";

    nativeBuildInputs = with pkgs; [
      gradle_9
      temurin-bin-25
    ];

    mitmCache = pkgs.gradle.fetchDeps {
      pkg = drv.finalPackage;
      data = ./deps.json;
    };

    env = {
      APP_VERSION = drv.version;
    };

    prePatch = ''
      cp -r ${frontend} frontend
      chmod -R +w .
    '';

    gradleFlags = [ "-PfrontendDistDir=frontend" ];

    gradleBuildTask = "bootJar";

    installPhase = ''
      install -Dm444 build/libs/backend-$version.jar $out/grimmory.jar
    '';

    passthru = { inherit frontend; };

    meta = { };
  });

  stb' = pkgs.stb.overrideAttrs (old: {
    version = "0-unstable-2026-04-15";

    src = pkgs.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "f0569113c93ad095470c54bf34a17b36646bbbb5";
      hash = "sha256-FkTeRO/AC5itykH4uWNsE0UeQTS34VtGGoej5QJiBlg=";
    };
  });

  epub4j = pkgs.stdenv.mkDerivation (drv: {
    pname = "epub4j";
    version = "1.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "grimmory-tools";
      repo = drv.pname;
      tag = "v${drv.version}";
      hash = "sha256-qZttIPbI1iI6rtyk8dGa/4EplyhB/lH27w8KeiEu8OM=";
    };

    sourceRoot = "${src.name}/epub4j-native/cpp";

    patches = [
      ./epub4j-stb.patch
    ];

    nativeBuildInputs = with pkgs; [
      cmake
      ninja
      pkg-config
    ];

    buildInputs = with pkgs; [
      gumbo
      libarchive
      libjpeg_turbo
      libpng
      libuchardet
      libwebp
      pugixml
      zlib

      openssl # required by libarchive
      stb' # required implicitly
    ];

    cmakeFlags = [
      "-DEPUB4J_NATIVE_USE_SYSTEM_GUMBO=ON"
      "-DEPUB4J_NATIVE_USE_SYSTEM_LIBARCHIVE=ON"
      "-DEPUB4J_NATIVE_USE_SYSTEM_LIBJPEG_TURBO=ON"
      "-DEPUB4J_NATIVE_USE_SYSTEM_LIBPNG=ON"
      "-DEPUB4J_NATIVE_USE_SYSTEM_UCHARDET=ON"
      "-DEPUB4J_NATIVE_USE_SYSTEM_LIBWEBP=ON"
      "-DEPUB4J_NATIVE_USE_SYSTEM_PUGIXML=ON"
      "-DEPUB4J_NATIVE_USE_SYSTEM_ZLIB=ON"
    ];
  });
in
(pkgs.writeShellScriptBin pname ''
  set -u
  exec java                                                \
    -Dapp.path-config="$1/app"                             \
    -Dapp.bookdrop-folder="$1/bookdrop"                    \
    -Djava.library.path=${pkgs.libarchive.lib}/lib         \
    -Depub4j.native.path=${epub4j}/lib/libepub4j_native.so \
    --enable-native-access=ALL-UNNAMED                     \
    --enable-preview                                       \
    -jar ${backend}/grimmory.jar
'').overrideAttrs {
  inherit pname version;
  name = "${pname}-${version}";

  meta = {
    mainProgram = pname;
    description = "A self-hosted application for managing your book collection";
    homepage = "https://github.com/grimmory-tools/grimmory";
  };
}
