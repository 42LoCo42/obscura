pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "zfullfs";
  version = "1.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = pname;
    tag = version;
    hash = "sha256-ORDyOsifgJFp9noD7Lg1tvCp7NgAucSDkqBp1cf1NEM=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    fuse3
    zfs
  ];

  CFLAGS = "-O3";

  meta = {
    description = "Tiny FUSE filesystem that reports the total size & allocation of a ZFS pool";
    homepage = "https://github.com/42LoCo42/zfullfs";
    mainProgram = pname;
  };
}
