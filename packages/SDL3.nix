pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "SDL3";
  version = "3.1.6";

  src = pkgs.fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    rev = "preview-${version}";
    hash = "sha256-MItZt5QeEz13BeCoLyXVUbk10ZHNyubq7dztjDq4nt4=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = (with pkgs; [
    # libffi
    # libsysprof-capture
    # pcre2
    # util-linux

    alsa-lib # alsa.pc
    dbus # dbus-1.pc
    ibus # ibus-1.0.pc
    kdePackages.wayland # wayland-client.pc wayland-egl.pc wayland-cursor.pc
    libGL # egl.pc GL/gl.h GL/glext.h
    libdecor # libdecor-0.pc
    libdrm # libdrm.pc
    libjack2 # jack.pc
    libpulseaudio # libpulse.pc
    libunwind # libunwind.pc libunwind-generic.pc
    libusb1 # libusb-1.0.pc
    libxkbcommon # xkbcommon.pc
    mesa # gbm.pc
    pipewire # libpipewire-0.3pc
    sndio # sndio.pc
  ]) ++ (with pkgs.xorg; [
    libX11 # x11.pc
    libXScrnSaver # xscrnsaver.pc
    libXcursor # xcursor.pc
    libXext # xext.pc
    libXfixes # xfixes.pc
    libXi # xi.pc
    libXrandr # xrandr.pc
    libXrender # xrender.pc
  ]);

  postFixup =
    let rpath = pkgs.lib.makeLibraryPath buildInputs; in ''
      for lib in $out/lib/*.so*; do
        if [ ! -L "$lib" ]; then
          patchelf --add-rpath "${rpath}" "$lib"
        fi
      done
    '';

  meta = {
    description = "Simple Directmedia Layer";
    homepage = "https://libsdl.org";
  };
}
