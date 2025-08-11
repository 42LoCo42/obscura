pkgs: pkgs.buildGoModule rec {
  pname = "socket-activate";
  version = "0.1.3";

  src = pkgs.fetchFromGitHub {
    owner = "mupuf";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-mYxFxYsSl2Tgb7fX2znQ2EKfo04n/cwrPU/eperWUdQ=";
  };

  patches = [
    # disable broken mode autoconfig
    ./0001-respect-mode-flag.patch

    # defaults to 100ms between attempts
    ./0002-make-connection-attempt-delay-configurable.patch
  ];

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-ODCJcLUGvS2XvK4EuCJu69Kq8bT+iJRwdBPD3qQkqtY=";

  meta = {
    description = "Socket-activate any service that doesn't support systemd's socket activation";
    homepage = "https://github.com/mupuf/socket-activate";
    mainProgram = pname;
  };
}
