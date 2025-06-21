pkgs: pkgs.buildGoModule rec {
  pname = "devzat";
  version = "0-unstable-2024-08-29";

  src = pkgs.fetchFromGitHub {
    owner = "quackduck";
    repo = pname;
    rev = "226f630955059f6b31e95f211fb0147a59d8edd5";
    hash = "sha256-EP6WDRiuG4AS9obdWhEoppsGwvs6JnkfA7tAhH969Sw=";
  };

  vendorHash = "sha256-SIG6eC6qwf5mFP99t4QzljhGYbnPfspcg7V3Bvk6p3A=";

  excludedPackages = [
    "./devzatapi"
    "./plugin"
  ];

  env.CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" ];
  stripAllList = [ "bin" ];

  meta = {
    description = "Custom SSH server for chatting";
    homepage = "https://github.com/quackduck/devzat";
    mainProgram = pname;
  };
}
