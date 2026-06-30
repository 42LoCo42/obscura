pkgs:
let
  pname = "grimmory";
  version = "3.2.2";

  src = pkgs.fetchFromGitHub {
    owner = "grimmory-tools";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-oh9qD7APvT/mFHSWKUgl/4lKN8RQRkix7kEN33wd3Jc=";
  };

  pnpm = pkgs.pnpm_11;
  gradle = pkgs.gradle_9;

  frontend = pkgs.stdenv.mkDerivation (drv: {
    pname = "${pname}-frontend";
    inherit version src;

    nativeBuildInputs = with pkgs; [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (drv) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-XeBqAEKEHe+qQivHX5thsn3xRYYDruwHL/5pYgGDlZI=";
    };

    buildPhase = ''
      CI=1 NG_CLI_ANALYTICS=false \
      pnpm -C frontend run build:prod
    '';

    installPhase = ''
      cp -r frontend/dist/grimmory/browser $out
    '';
  });

  backend = pkgs.stdenv.mkDerivation (drv: {
    pname = "${pname}-backend";
    inherit version src;
    sourceRoot = "${src.name}/backend";

    nativeBuildInputs = [
      gradle
      gradle.jdk
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

  stb' = pkgs.infuse pkgs.stb {
    __output = {
      version.__assign = "0-unstable-2026-04-15";

      src.__output = {
        rev.__assign = "f0569113c93ad095470c54bf34a17b36646bbbb5";
        hash.__assign = "sha256-FkTeRO/AC5itykH4uWNsE0UeQTS34VtGGoej5QJiBlg=";
      };
    };
  };

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

  passthru = { inherit frontend backend; };

  meta = {
    mainProgram = pname;
    description = "A self-hosted application for managing your book collection";
    homepage = "https://github.com/grimmory-tools/grimmory";
  };
}
