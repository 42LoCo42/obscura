pkgs: pkgs.stdenv.mkDerivation (drv: {
  pname = "gst-instruments";
  version = "0.3.2";

  src = pkgs.fetchFromGitHub {
    owner = "kirushyk";
    repo = drv.pname;
    tag = "v${drv.version}";
    hash = "sha256-alQurY/5N/OvwvYVe97DgyYJfEXNiuhpTHhJJ0ahTUU=";
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
  ];

  buildInputs = with pkgs; [
    glib
    gst_all_1.gstreamer
  ];

  meta = {
    description = "Easy-to-use profiler for GStreamer";
    homepage = "https://github.com/kirushyk/gst-instruments";
  };
})
