{ buildGoModule
, buildNpmPackage
, dlib
, exiftool
, fetchFromGitHub
, ffmpeg-headless
, libheif
, libjpeg
, makeBinaryWrapper
, openblas
, pkg-config
, runCommand
}:
let
  pname = "photoview";
  version = "ddacba8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-Jdebpsya2IVI4O7Ar45n54ovKh3Y1mVdd/xC7JoSP2M=";
  };

  api = buildGoModule {
    pname = "${pname}-api";
    inherit version;
    src = "${src}/api";
    vendorHash = "sha256-Tn4OxSV41s/4n2Q3teJRJNc39s6eKW4xE9wW/CIR5Fg=";

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      dlib
      libheif
      libjpeg
      openblas
    ];

    postInstall = ''
      cp -r data/models $out
    '';
  };

  ui = buildNpmPackage {
    pname = "${pname}-ui";
    inherit version;
    src = "${src}/ui";
    npmDepsHash = "sha256-wUbfq+7SuJUBxfy9TxHVda8A0g4mmYCbzJT64XBN2mI=";
  };
in
runCommand pname
{
  inherit pname version;
  nativeBuildInputs = [ makeBinaryWrapper ];
  meta = {
    description = "Photo gallery for self-hosted personal servers";
    homepage = "https://photoview.github.io";
    mainProgram = pname;
  };
} ''
  makeWrapper ${api}/bin/api $out/bin/photoview                      \
    --suffix PATH : ${ffmpeg-headless}/bin                           \
    --suffix PATH : ${exiftool}/bin                                  \
    --set PHOTOVIEW_SERVE_UI 1                                       \
    --set PHOTOVIEW_UI_PATH ${ui}/lib/node_modules/photoview-ui/dist \
    --set PHOTOVIEW_FACE_RECOGNITION_MODELS_PATH ${api}/models
''
