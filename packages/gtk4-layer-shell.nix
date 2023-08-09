{ fetchFromGitHub
, stdenv

, meson
, ninja
, pkg-config
, vala

, gobject-introspection
, gtk4
}: stdenv.mkDerivation rec {
  pname = "gtk4-layer-shell";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "wmww";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MG/YW4AhC2joUX93Y/pzV4s8TrCo5Z/I3hAT70jW8dw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gobject-introspection
    gtk4
  ];

  mesonFlags = [ "-Dexamples=true" ];

  meta = {
    description = "A library to desktop components for Wayland using the Layer Shell protocol and GTK4";
    homepage = "https://github.com/wmww/gtk4-layer-shell";
    pkgConfigModules = [ "gtk4-layer-shell-0" ];
    mainProgram = "gtk4-layer-demo";
  };
}
