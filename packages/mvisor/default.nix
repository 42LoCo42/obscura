pkgs:
let inherit (pkgs.lib) filter hasInfix; in
pkgs.stdenv.mkDerivation rec {
  pname = "mvisor";
  version = "2.7.3-unstable-2025-08-08";

  src = pkgs.fetchFromGitHub {
    owner = "tenclass";
    repo = pname;
    rev = "5b2646b25c41a2d3f4152982947d27bc11710069";
    hash = "sha256-9RTo6/XsjLX0EDg6KTcg8lhd1gtENpWlrABKiyvjsKA=";
  };

  nativeBuildInputs = with pkgs; [
    acpica-tools
    gdb
    meson
    ninja
    pkg-config
    protobuf
  ];

  buildInputs = with pkgs; [
    SDL2
    alsa-lib
    glib
    gtk3
    openssl
    pixman
    yaml-cpp
    zlib
    zstd

    (virglrenderer.overrideAttrs (old: {
      version = "0.10.4";

      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "virgl";
        repo = "virglrenderer";
        rev = "8df4cba170940dad9350a99900293adbcef39b6c";
        hash = "sha256-D4pMokM2nnnL1iJDupAY+Q1L3p0wD6RsfKxxNqZFE0U=";
      };

      mesonFlags = filter
        (x: !hasInfix "drm-renderers" x)
        (old.mesonFlags or [ ]);

      env.NIX_CFLAGS_COMPILE = "-Wno-error=enum-int-mismatch";
    }))
  ];

  mesonFlags = let inherit (pkgs.lib) mesonBool; in [
    (mesonBool "gtk" true)
    (mesonBool "qxl" true)
    (mesonBool "sdl" true)
    (mesonBool "vgpu" true)
    (mesonBool "mdebugger" true)
  ];

  mesonInstallFlags = [
    "--destdir ${placeholder "out"}"
  ];

  postInstall = ''
    install -Dm555                                \
      $out/mnt/server/opt/mvisor/build/bin/mvisor \
      $out/bin/mvisor

    rm -rf $out/mnt

    cp -r $src/{config,share} $out
  '';

  meta = {
    description = "A mini x86 hypervisor";
    homepage = "https://github.com/tenclass/mvisor";
    mainProgram = pname;
    broken = pkgs.stdenv.hostPlatform.isAarch64;
  };
}
