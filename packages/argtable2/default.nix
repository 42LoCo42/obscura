pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "argtable2";
  version = "2.13";

  src = pkgs.fetchFromGitHub {
    owner = "jonathanmarvens";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-K6++QVvpcPR+BYxbDRZ24sY0+PgIaQ3t1ktt3zZGh6Q=";
  };

  patches = [
    # fixes some implicit function declarations
    ./0001-arg_int.c-include-ctype.h.patch
  ];

  enableParallelBuilding = true;

  meta = {
    description = "An ANSI C command line parser";
    homepage = "https://argtable.sourceforge.io";
  };
}
