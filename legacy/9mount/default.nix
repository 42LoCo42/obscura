pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "9mount";
  version = "1.3";

  src = pkgs.fetchFromGitHub {
    owner = "sqweek";
    repo = pname;
    tag = version;
    hash = "sha256-TMiBvz+Eu/vD6SGLkg36rj0TJQ6ZdvLiSU2iENh8vQg=";
  };

  patches = [
    # don't apply root:users and setuid permissions to installed binaries
    ./unpriv.patch
  ];

  enableParallelBuilding = true;

  installPhase = "make prefix=$out install";

  meta = {
    description = "A set of SUID tools for mounting 9p filesystems via v9fs";
    homepage = "https://sqweek.net/code/9mount";
  };
}
