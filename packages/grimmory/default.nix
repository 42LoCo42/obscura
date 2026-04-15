pkgs:
let
  pname = "grimmory";
  version = "2.3.0";

  src = pkgs.fetchFromGitHub {
    owner = "grimmory-tools";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-pXihT21XmXslED4aDPXwe2t56hrSFVkt6LqfN0Uzu/8=";
  };

  frontend = pkgs.buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version src;
    sourceRoot = "${src.name}/booklore-ui";

    npmDepsHash = "sha256-ivpGcy7z3N0Iwi5WPQl1oQ5BqhGIiQTWk0tM+akhSbs=";
    npmBuildFlags = [ "--configuration=production" ];

    installPhase = ''
      cp -r dist/grimmory/browser $out
    '';
  };

  backend = pkgs.stdenv.mkDerivation (drv: {
    inherit pname version src;
    sourceRoot = "${src.name}/booklore-api";

    nativeBuildInputs = with pkgs; [
      gradle
      rsync
      temurin-bin-25
    ];

    mitmCache = pkgs.gradle.fetchDeps {
      pkg = drv.finalPackage;
      data = ./deps.json;
    };

    prePatch = ''
      substituteInPlace build.gradle \
        --replace-fail 0.0.1-SNAPSHOT $version

      # copy & make frontend writable because
      # the build process wants to change some files
      rsync -a --chmod +w ${frontend}/ frontend/
    '';

    gradleFlags = [ "-PfrontendDistDir=frontend" ];
    gradleBuildTask = "bootJar";

    installPhase = ''
      mkdir -p $out
      cp build/libs/booklore-api-$version.jar $out/grimmory.jar
    '';

    meta = {
      description = "A self-hosted application for managing your book collection";
      homepage = "https://github.com/grimmory-tools/grimmory";
    };
  });
in
backend
