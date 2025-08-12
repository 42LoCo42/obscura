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

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-QQfUntBcQY12zh5gE+R+wfWuOwc7meqk015qi7mnKNs=";
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
