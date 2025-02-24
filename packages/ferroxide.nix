pkgs: pkgs.buildGoModule rec {
  pname = "ferroxide";
  version = "0.4.0-unstable-2025-02-12";

  src = pkgs.fetchFromGitHub {
    owner = "acheong08";
    repo = pname;
    rev = "927b502fc3f70f1ea34d6a143e5ebd3e17c0f33a";
    hash = "sha256-9KsLzcDrBDDNf5DVEiGPd8MZPeTPq41Voj+tWb2CA+M=";
  };

  vendorHash = "sha256-NuN2zgr7Eh8j88lB8i3WJzx6xuCLe9tBZtL5aD6VTcM=";

  subPackages = [ "cmd/${pname}" ];

  meta = {
    description = "A community fork of https://github.com/emersion/hydroxide";
    homepage = "https://github.com/acheong08/ferroxide";
    mainProgram = pname;
  };
}
