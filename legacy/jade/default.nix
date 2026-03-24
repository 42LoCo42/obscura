pkgs: pkgs.buildGoModule rec {
  pname = "jade";
  version = "1.1.3-unstable-2023-08-09";

  src = pkgs.fetchFromGitHub {
    owner = "joker";
    repo = pname;
    rev = "2a1184910df35054e730cdd42908d87d0a6e21b3";
    hash = "sha256-spydTTkaIyQKfiGCP2lzUFN16DQElQnPGuJVzcvq5FY=";
  };

  vendorHash = "sha256-n4WeygbreZQwp6immjWzTT/IjAedZv27joSVU4wBPWI=";

  meta = {
    description = "Pug template engine for Go";
    homepage = "https://github.com/Joker/jade";
    mainProgram = pname;
  };
}
