pkgs:
let
  # last known good libgpod 0.8.3 (using gettext 0.22.5)
  pkgs-fixed = (import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/be9e214982e20b8310878ac2baa063a961c1bdf6";
    sha256 = "sha256-HM791ZQtXV93xtCY+ZxG1REzhQenSQO020cu6rHtAPk=";
  })) { inherit (pkgs.stdenv.hostPlatform) system; };
in
pkgs.stdenv.mkDerivation rec {
  pname = "fusepod";
  version = "0.5.2-unstable-2022-01-11";

  src = pkgs.fetchFromGitHub {
    owner = "keegancsmith";
    repo = "FUSEPod";
    rev = "ab85982388f4968e09bcd434a3a1e9ab77af42b9";
    hash = "sha256-r2+iQPzjX82utqPtHpkBgaw5d/ds3pEY1Q8TQR5SIqo=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    fuse
    taglib

    pkgs-fixed.libgpod
  ];

  meta = {
    description = "A userspace filesystem which mounts your iPod.";
    homepage = "https://github.com/keegancsmith/FUSEPod";
    mainProgram = pname;
  };
}
