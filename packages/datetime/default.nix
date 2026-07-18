pkgs:
let
  inherit (pkgs.lib) getExe;
  pnpm = pkgs.pnpm_10;
in
pkgs.stdenv.mkDerivation (drv: {
  pname = "datetime";
  version = "0.2.3";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = "what-datetime-is-it-right-now-dot-com";
    tag = drv.version;
    hash = "sha256-pQI8bTG0a58WDSUfHoul2T5sPdRsb6KrlcDbKkyOePY=";
  };

  nativeBuildInputs = with pkgs; [
    makeBinaryWrapper

    nodejs
    pnpm
    pnpmConfigHook

    # for sharp build:
    pkg-config
    python3
  ];

  buildInputs = with pkgs; [
    vips
  ];

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit pnpm;
    inherit (drv) pname version src;
    fetcherVersion = 3;
    hash = "sha256-kDCSZAoJNenjgCZlcrb8Tx3ZaZRpbYOt2jTGfuy0xkg=";
  };

  env = {
    SHARP_FORCE_GLOBAL_LIBVIPS = 1;
    npm_config_nodedir = pkgs.nodejs;
  };

  buildPhase = ''
    export MAKEFLAGS="-j$NIX_BUILD_CORES"
    (cd node_modules/.pnpm/node_modules/sharp; npm run install)
    pnpm build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r public $out/app

    makeWrapper                                \
      ${getExe pkgs.python3} $out/bin/datetime \
      --add-flags "-m http.server -d $out/app"
  '';

  meta = {
    description = "A site that tells you what date and time it is right now";
    homepage = "https://github.com/42LoCo42/what-datetime-is-it-right-now-dot-com";
    mainProgram = drv.pname;
  };
})
