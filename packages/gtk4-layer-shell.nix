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

  meta.pkgConfigModules = [ "gtk4-layer-shell-0" ];
}
