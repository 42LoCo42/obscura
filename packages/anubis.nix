pkgs: pkgs.buildGoModule rec {
  pname = "anubis";
  version = "1.13.0";

  src = pkgs.fetchFromGitHub {
    owner = "TecharoHQ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Wx/twf8rObOohuM6x0vz8O578JpaGk30r9ZZH1LNgvU=";
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
