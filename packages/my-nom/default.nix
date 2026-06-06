pkgs: pkgs.infuse pkgs.nix-output-monitor {
  __output = {
    version.__assign = "2.1.8-unstable-2026-05-22";

    src.__assign = pkgs.fetchFromGitHub {
      owner = "maralorn";
      repo = "nix-output-monitor";
      rev = "0e855e51c1700e35456faa3dee2e50024f602f42";
      hash = "sha256-8viiPvLkj0vFdG1kgcNuKXoenyTBvKd+GQ62jwbONns=";
    };
  };
}
