pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "bun2nix";
  version = "1.5.1";

  src = pkgs.fetchFromGitHub {
    owner = "baileyluTCD";
    repo = pname;
    tag = version;
    hash = "sha256-rUpcATQ0LiY8IYRndqTlPUhF4YGJH3lM2aMOs5vBDGM=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    openssl
  ];

  cargoHash = "sha256-K9rXGHyQ/uzj3iDZ3uI+wFOIvMVI+klZu2GhSDk7GLY=";

  meta = {
    description = "A fast rust based bun lockfile to nix expression converter";
    homepage = "https://github.com/baileyluTCD/bun2nix";
    mainProgram = pname;
  };
}
