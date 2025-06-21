pkgs: pkgs.stdenv.mkDerivation rec {
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
    libgpod
    taglib
  ];

  meta = {
    description = "A userspace filesystem which mounts your iPod.";
    homepage = "https://github.com/keegancsmith/FUSEPod";
    mainProgram = pname;
  };
}
