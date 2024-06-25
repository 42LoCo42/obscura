pkgs: pkgs.buildGoModule rec {
  pname = "jade";
  version = "2a11849";
  src = pkgs.fetchFromGitHub {
    owner = "joker";
    repo = pname;
    rev = version;
    hash = "sha256-spydTTkaIyQKfiGCP2lzUFN16DQElQnPGuJVzcvq5FY=";
  };
  vendorHash = "sha256-n4WeygbreZQwp6immjWzTT/IjAedZv27joSVU4wBPWI=";

  meta = {
    description = "Pug template engine for Go";
    homepage = "https://github.com/Joker/jade";
    mainProgram = "jade";
  };
}
