pkgs:
let
  pname = "molecule";
  version = "1.3.0";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = pname;
    tag = version;
    hash = "sha256-gWjvJ6/rowlZb3zyYi7F93hw0Wxk35O8YX05kIUsads=";
  };

  frontend = pkgs.stdenv.mkDerivation (drv: {
    pname = "molecule-frontend";
    inherit version;
    src = "${src}/frontend";

    nativeBuildInputs = with pkgs; [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (drv) pname src version;
      inherit (pkgs) pnpm;
      fetcherVersion = 4;
      hash = "sha256-zmJEj88JVvS+AOMsrYqVdKoujfLRVzYFPNZPTLpYnMQ=";
    };

    buildPhase = ''
      bash build.sh
    '';

    installPhase = ''
      cp -r dist $out
    '';
  });

  backend = pkgs.buildGoModule {
    pname = "${pname}-backend";
    inherit version;
    src = "${src}/backend";

    env = {
      CGO_CFLAGS_ALLOW = "-fno-strict-overflow";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      pipewire
    ];

    preBuild = ''
      cp -r ${frontend} dist
    '';

    tags = [ "release" ];
    ldflags = [ "-s" "-X main.version=${version}" ];
    vendorHash = "sha256-0Qxw+MUYVgzgWB8vi3HBYtVXSq/btfh4ZfV/m1chNrA=";

    meta = {
      description = "Matrix call widget with system audio sharing";
      homepage = "https://github.com/42LoCo42/molecule";
      mainProgram = pname;
    };
  };
in
backend
