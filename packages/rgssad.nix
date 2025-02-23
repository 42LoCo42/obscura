pkgs: pkgs.perlPackages.buildPerlPackage {
  pname = "Archive-Rgssad";
  version = "0.11";

  src = pkgs.fetchurl {
    url = "mirror://cpan/authors/id/W/WA/WATASHI/Archive-Rgssad-0.11.tar.gz";
    hash = "sha256-AAhuRPv2yEihG3rU1iAgy1tx6rxgmWujtnZzNOrK6pc=";
  };

  buildInputs = with pkgs.perlPackages; [ IOString ];

  meta = {
    description = "Provide an interface to RGSS (ruby game scripting system) archive files";
  };
}
