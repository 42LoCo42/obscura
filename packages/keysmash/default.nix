pkgs:
let
  sound_dir = (pkgs.fetchFromGitHub {
    owner = "skkeeper";
    repo = "linux-clicky";
    rev = "ef5070829adfc7b3906852849d574c80caf4196c";
    hash = "sha256-W+NJZ8ARza1Brh5fLlz7hUYniQDpEGOvZQZpb2KDQRI=";
  }) + /sounds;
in
pkgs.stdenv.mkDerivation (drv: {
  pname = "keysmash";
  version = "1.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = drv.pname;
    tag = drv.version;
    hash = "sha256-9Qv9/cJH8KDjHKur3X0K7hfw5+RMVpu4H6mZDnF14Vk=";
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
  ];

  buildInputs = with pkgs; [
    raylib
  ];

  mesonBuildType = "release";

  mesonFlags = [
    "-Dkeyd=${pkgs.keyd.src}/src"
    "-Dsound_dir=${placeholder "out"}/share/sounds/keysmash"
  ];

  postInstall = ''
    mkdir -p $out/share/sounds
    cp -r ${sound_dir} $out/share/sounds/keysmash
  '';

  meta = {
    description = "Adds some satisfying keyboard noises when you type stuff";
    homepage = "https://github.com/42LoCo42/keysmash";
    mainProgram = drv.pname;
  };
})
