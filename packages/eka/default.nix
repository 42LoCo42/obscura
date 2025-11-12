pkgs: pkgs.rustPlatform.buildRustPackage (drv: {
  pname = "eka";
  version = "0.3.0-unstable-2025-11-12";

  src = pkgs.fetchFromGitHub {
    owner = "ekala-project";
    repo = drv.pname;
    rev = "e699f085b1ce4c37d9706bd445223f5cb430c626";
    hash = "sha256-6vQ8sjmja+KooKKknyJmlyZPmJSZ7NCmE9yl2JWjJUY=";
  };

  cargoHash = "sha256-GuNN0dddo8jhMMmBRNIdbV7R0yTQOc54ci++8K51Clk=";

  env = {
    # static
    EKA_ROOT_COMMIT_HASH = "4abbd2644bc3585e9be95deb277ccf48f6ed26ac";
    EKA_ORIGIN_URL = "https://github.com/ekala-project/eka";

    # nix-lock/0.1.6
    EKA_LOCK_REV = "e711aa1f48d877652dd2ba724d4af752be7b5371";

    PROTO_ROOT = pkgs.fetchFromGitHub {
      owner = "nrdxp";
      repo = "snix";
      rev = "5878b3e46de692ab0559570cfaf7c660304ca788"; # "protos" branch
      hash = "sha256-1ZsRIY/n8r9eJvRRO71+cENsdwTolVH7ACWUr0cfncI=";
    };

    SNIX_BUILD_SANDBOX_SHELL = "/bin/sh";
  };

  nativeBuildInputs = with pkgs; [
    mold
    protobuf
  ];

  meta = {
    description = "A command-line tool for decentralized software dependency management using the Atom Protocol";
    homepage = "https://github.com/ekala-project/eka";
    mainProgram = drv.pname;
  };
})
