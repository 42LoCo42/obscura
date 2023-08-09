{ fetchFromGitHub
, rustPlatform

, pkg-config

, cairo
, gdk-pixbuf
, glib
, graphene
, gtk4
, gtk4-layer-shell
, harfbuzz
, pango
}: rustPlatform.buildRustPackage rec {
  pname = "wayland-shell";
  version = "0";

  src = fetchFromGitHub {
    owner = "nilsherzig";
    repo = pname;
    rev = "0c1947cb0d7eb0f74973ec14a79e28f9ac71b9af";
    hash = "sha256-GwFATmR66lS3ImqgU3Wz7mA24Q2gs3FW0ZbifuZJ78g=";
  };
  cargoHash = "sha256-WoQrjwa6/JFQo9KH50qbzf/LomDqn7BZ8DWn9V8BZLw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    graphene
    gtk4
    gtk4-layer-shell
    harfbuzz
    pango
  ];

  meta = {
    description = "Small-scale replacement of the GNOME Shell";
    homepage = "https://github.com/nilsherzig/wayland-shell";
  };
}
