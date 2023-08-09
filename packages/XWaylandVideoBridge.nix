{ fetchgit
, stdenv

, cmake
, extra-cmake-modules
, libsForQt5
}:
let
  kpipewire-custom = libsForQt5.kpipewire.overrideAttrs (old: {
    src = fetchgit {
      url = "https://invent.kde.org/plasma/kpipewire";
      rev = "31b24a4cfc021d7f077499dc8af71b4a22b51ffc";
      hash = "sha256-ML1MYNWph/EXgou7Jn3tSfp6m1C32oIRi9Fi4AXQNIg=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "XWaylandVideoBridge";
  version = "4a72e7c19884c5a87a2cbfcf01c5293199196e1e";

  src = fetchgit {
    url = "https://invent.kde.org/system/xwaylandvideobridge";
    rev = version;
    hash = "sha256-tkLvKZ52bbcHrTSEciSlTv5UVncJsnFW7IoWWiTsols=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = with libsForQt5; [
    ki18n
    knotifications
    kpipewire-custom
    kwidgetsaddons
    kwindowsystem
    qt5.qtx11extras.dev
    wrapQtAppsHook
  ];

  meta = {
    description = "Utility to allow streaming Wayland windows to X applications";
    homepage = "https://invent.kde.org/system/xwaylandvideobridge";
    mainProgram = "xwaylandvideobridge";
  };
}
