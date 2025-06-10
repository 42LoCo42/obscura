pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "hybrid-bar";
  version = "e5d7dbc";

  src = pkgs.fetchFromGitHub {
    owner = "vars1ty";
    repo = "hybridbar";
    rev = version;
    hash = "sha256-pkKUhNBE/EV9YsTfJ7k9A8WPHhhGnEmaYJ/ymFdnlrI=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    glib
    gtk-layer-shell
    gtk3
  ];

  doCheck = false; # checks make build take twice as long

  meta = {
    description = "A status bar focused on wlroots Wayland compositors";
    homepage = "https://github.com/vars1ty/HybridBar";
    mainProgram = "hybrid-bar";
  };
}
