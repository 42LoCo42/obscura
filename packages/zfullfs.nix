pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "zfullfs";
  version = "1";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = pname;
    rev = version;
    hash = "sha256-Cy9iFFXFoPQ5zD/p02n5/DngRawNCPt5F3PW8Glx0ds=";
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
