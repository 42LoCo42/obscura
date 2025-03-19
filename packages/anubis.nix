pkgs: pkgs.buildGoModule rec {
  pname = "anubis";
  version = "1.12.1";

  src = pkgs.fetchFromGitHub {
    owner = "TecharoHQ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GNdDUVsJG4/hfixHXP9KgRHJ51NerjpU2s/9SBcKq4I=";
  };

  ldflags = [ "-s" "-w" ];
  subPackages = [ "cmd/anubis" ];
  vendorHash = "sha256-jw/iDhOYxx82sO3o9G5c6HfSpm1hAl6f3y5Y7vbfA7U=";

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://github.com/TecharoHQ/anubis";
    mainProgram = pname;
  };
}
