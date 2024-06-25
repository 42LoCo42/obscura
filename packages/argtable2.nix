pkgs: pkgs.stdenv.mkDerivation {
  pname = "argtable2";
  version = "2.13";

  src = pkgs.fetchurl {
    url = "mirror://sourceforge/argtable/argtable2-13.tar.gz";
    hash = "sha256-j3fop87VMBr24i9HMC/bw7H/QfK4PEPHeuXKBBdx3b8=";
  };

  meta = {
    description = "An ANSI C command line parser";
    homepage = "https://argtable.sourceforge.io";
  };
}
