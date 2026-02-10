# TODO https://github.com/NixOS/nixpkgs/pull/488876

pkgs:
let
  pname = "photoview";
  version = "v2.4.0";

  src = pkgs.fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = version;
    hash = "sha256-ZfvBdQlyqONsrviZGL22Kt+AiPaVWwdoREDUrHDYyIs=";
  };

  api = pkgs.buildGoModule {
    pname = "${pname}-api";
    inherit version;
    src = "${src}/api";
    vendorHash = "sha256-Tn4OxSV41s/4n2Q3teJRJNc39s6eKW4xE9wW/CIR5Fg=";

    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [
      dlib
      libheif
      libjpeg
      openblas
    ];

    postInstall = ''
      cp -r data/models $out
    '';
  };

  ui = pkgs.buildNpmPackage {
    pname = "${pname}-ui";
    inherit version;
    src = "${src}/ui";
    npmDepsHash = "sha256-wUbfq+7SuJUBxfy9TxHVda8A0g4mmYCbzJT64XBN2mI=";

    VERSION = version;
    BUILD_DATE = "0";
  };

  path = with pkgs; lib.makeBinPath [ exiftool ffmpeg-headless ];
in
pkgs.runCommand pname
{
  inherit pname version;
  nativeBuildInputs = with pkgs; [ makeBinaryWrapper ];
  meta = {
    description = "Photo gallery for self-hosted personal servers";
    homepage = "https://photoview.github.io";
    mainProgram = pname;
  };
} ''
  makeWrapper ${api}/bin/api $out/bin/photoview                      \
    --suffix PATH : ${path}                                          \
    --set PHOTOVIEW_SERVE_UI 1                                       \
    --set PHOTOVIEW_UI_PATH ${ui}/lib/node_modules/photoview-ui/dist \
    --set PHOTOVIEW_FACE_RECOGNITION_MODELS_PATH ${api}/models
''
