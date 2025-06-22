pkgs: (import (pkgs.fetchFromGitHub {
  owner = "utdemir";
  repo = "nix-tree";
  tag = "v0.6.3";
  hash = "sha256-579p1uqhICfsBl1QntcgyQwTNtbiho1cuNLDjjXQ+sM=";
})).packages.${pkgs.system}.default
