pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "CatgirlDownloader";
  version = "0.2.7";

  src = pkgs.fetchFromGitHub {
    owner = "NyarchLinux";
    repo = pname;
    rev = version;
    hash = "sha256-u5Rea2JkeLA5AOys9JfvLi6mfKbElbfZWdWVErUl1BU=";
  };
  patches = [ ./configdir.patch ];

  nativeBuildInputs = with pkgs; [
    desktop-file-utils
    gettext
    meson
    ninja
    wrapGAppsHook4

    # technically not needed but
    # makes scary warning go away >_<
    pkg-config
  ];

  buildInputs = with pkgs; [
    gobject-introspection
    libadwaita

    (python3.withPackages (p: with p; [
      pygobject3
      requests
    ]))
  ];

  meta = {
    description = "A GTK4 application that downloads images of catgirls based on https://nekos.moe";
    homepage = "https://github.com/NyarchLinux/CatgirlDownloader";
    mainProgram = pkgs.lib.toLower pname;
  };
}
