pkgs: pkgs.buildGoModule rec {
  pname = "socket-activate";
  version = "0.1-unstable-2020-07-16";

  src = pkgs.fetchFromGitHub {
    owner = "cherti";
    repo = pname;
    rev = "3b3da8f95945010ce3ee5200935aa2c2d950d75d";
    hash = "sha256-YmOshzWQIsosW12Lvp85RbTBNJNvBAYvrpAXd3etRJo=";
  };

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-ODCJcLUGvS2XvK4EuCJu69Kq8bT+iJRwdBPD3qQkqtY=";

  meta = {
    description = "Socket-activate any service that doesn't support systemd's socket activation";
    homepage = "https://github.com/cherti/socket-activate";
    mainProgram = pname;
  };
}
