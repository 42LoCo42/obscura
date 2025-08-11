pkgs:
let
  src = pkgs.fetchFromGitHub {
    owner = "baileyluTCD";
    repo = "bun2nix";
    tag = "1.5.1";
    hash = "sha256-rUpcATQ0LiY8IYRndqTlPUhF4YGJH3lM2aMOs5vBDGM=";
  };
in
(import "${src}/nix/package.nix" {
  inherit pkgs;
  flake = src;
}).overrideAttrs (old: {
  meta = old.meta // {
    mainProgram = old.pname;
  };
})
