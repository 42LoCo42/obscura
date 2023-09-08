{ fetchFromGitHub
, stdenv

, pkg-config

, fuse
, libgpod
, taglib
}: stdenv.mkDerivation {
  pname = "fusepod";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "keegancsmith";
    repo = "FUSEPod";
    rev = "ab85982";
    hash = "sha256-r2+iQPzjX82utqPtHpkBgaw5d/ds3pEY1Q8TQR5SIqo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse
    libgpod
    taglib
  ];

  meta = {
    description = "A userspace filesystem which mounts your iPod.";
    homepage = "https://github.com/keegancsmith/FUSEPod";
  };
}
