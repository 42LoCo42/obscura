pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "gitlogue";
  version = "0.3.0";

  src = pkgs.fetchFromGitHub {
    owner = "unhappychoice";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-IKCjv33I6bM5PSp1IBXEArHgNF1hV9J+Zko0uV2OPZA=";
  };

  patches = [
    # git2 should use system libgit2 & openssl
    ./no-vendored-libs.patch
  ];

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit src patches;
    hash = "sha256-QO6BFLBWUCg2PTK15mPahOci3t3LrIBLTKALguTNvZQ=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    libgit2
    openssl
  ];

  meta = {
    description = "A cinematic Git commit replay tool for the terminal";
    homepage = "https://github.com/unhappychoice/gitlogue";
    mainProgram = pname;
  };
}
