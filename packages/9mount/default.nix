pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "9mount";
  version = "1.3";

  src = pkgs.fetchurl {
    url = "http://sqweek.net/9p/9mount-${version}.tar.gz";
    hash = "sha256-gg2AubR40F7LAirWWEd7N8/CQUqGacOvF9GSpSIGTBc=";
  };

  patches = [ ./unpriv.patch ];
  installPhase = "make prefix=$out install";

  meta = {
    description = "A set of SUID tools for mounting 9p filesystems via v9fs";
    homepage = "https://sqweek.net/code/9mount";
  };
}
