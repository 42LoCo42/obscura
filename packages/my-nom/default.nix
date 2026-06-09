pkgs: pkgs.infuse pkgs.nix-output-monitor {
  __output = {
    version.__assign = "2.1.8-unstable-2026-06-08";

    src.__assign = pkgs.fetchFromGitHub {
      owner = "maralorn";
      repo = "nix-output-monitor";
      rev = "388f56120f655a9cf4512e697b2c2afa06fe7434";
      hash = "sha256-3N+PVFpsnBtQ11Vk9OKm1q9dE0d5fxGsEDyfwoxpYaE=";
    };

    propagatedBuildInputs.__append = [ pkgs.haskellPackages.hinotify ];
  };
}
