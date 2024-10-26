pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "vwifi";
  version = "6.3";

  src = pkgs.fetchFromGitHub {
    owner = "Raizo62";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4drx54aglQEupgvghqbZODJ20t5KJj1CIS0ArYhhwiY=";
  };

  enableParallelBuilding = true;

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man/man1"

    "NETLINK_FLAGS_PATH=${pkgs.libnl.dev}/include/libnl3"
    "NETLINK_LIBS_PATH=${pkgs.libnl.out}/lib"

    "EUID=0"
  ];

  meta = {
    description = "Simulator of WiFi (802.11) interfaces to communicate between several Virtual Machines";
    homepage = "https://github.com/Raizo62/vwifi";
    # has no mainProgram since all tools are equally important
  };
}
