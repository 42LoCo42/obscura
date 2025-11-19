pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "gitlogue";
  version = "0.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "unhappychoice";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-b5tfYSZXvWAJMSRfKbcD7d69HyH6YRhJ9oCQUElWHfY=";
  };

  patches = [
    # git2 should use system libgit2 & openssl
    ./no-vendored-libs.patch
  ];

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit src patches;
    hash = "sha256-hvKory8YQn0GlUs/qAH5PS/AlZg6z6wmVGuzz/LSgQg=";
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
