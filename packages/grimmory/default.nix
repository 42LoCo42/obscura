pkgs:
let
  pname = "grimmory";
  version = "3.0.3";

  src = pkgs.fetchFromGitHub {
    owner = "grimmory-tools";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-dWZcCX0Tp+yPp+4vBERYEwu+rysCzJ9QfMQhD65t1vQ=";
  };

  yarn = pkgs.yarn-berry_4;

  frontend = pkgs.stdenv.mkDerivation (drv: {
    pname = "${pname}-frontend";
    inherit version src;
    sourceRoot = "${src.name}/frontend";

    nativeBuildInputs = with pkgs; [
      nodejs
      yarn
      yarn.yarnBerryConfigHook
    ];

    missingHashes = ./missing-hashes.json;

    offlineCache = yarn.fetchYarnBerryDeps {
      inherit (drv) src sourceRoot missingHashes;
      hash = "sha256-YU7OMdcwkwyJl84j0L0gUhHfngdpBaiHzgRydkeJC+s=";
    };

    buildPhase = ''
      yarn run build:prod
    '';

    installPhase = ''
      cp -r dist/grimmory/browser $out
    '';
  });

  backend = pkgs.stdenv.mkDerivation (drv: {
    inherit pname version src;
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

    meta = {
      description = "A self-hosted application for managing your book collection";
      homepage = "https://github.com/grimmory-tools/grimmory";
    };
  });
in
backend
