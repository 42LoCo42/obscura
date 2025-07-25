pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "souk";
  version = "0-unstable-2024-04-07";

  src = pkgs.fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "haecker-felix";
    repo = pname;
    rev = "66608041a8c90a4f4695f11235bfc33604d77b95";
    hash = "sha256-iPoDZFY1lTvj41HrwYf+VepCw4Esn/rtz7Tyg0fPdpQ=";
  };

  patches = [
    # let nix supply vcs_tag
    ./vcs_tag.patch
  ];

  mesonFlags = [ "-Dvcs_tag=${version}" ];

  cargoDeps = pkgs.rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "libflatpak-0.3.0" = "sha256-UIrWnBVTpvdIv5CYKi6LpY08G+FAluT7X0JR9o68Nsg=";
    };
  };

  nativeBuildInputs = with pkgs; [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = with pkgs; [
    dbus
    flatpak
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    libxmlb
    openssl
    sqlite
  ];

  meta = {
    description = "Independent Flatpak App Store";
    homepage = "https://gitlab.gnome.org/haecker-felix/souk";
    mainProgram = pname;
  };
}
