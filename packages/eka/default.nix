pkgs: pkgs.rustPlatform.buildRustPackage (drv: {
  pname = "eka";
  version = "0.3.0-unstable-2025-11-08";

  src = pkgs.fetchFromGitHub {
    owner = "ekala-project";
    repo = drv.pname;
    rev = "047e578bc285a55c998a87acd6ebca91c2374877";
    hash = "sha256-l5oSpg8HYtz0Yk9IYOdQiSZKNc9kzluNBd9oZBooZ/4=";
  };

  cargoHash = "sha256-Sg3e8yv75dg8T9qyJM7rNz+sKH/hH1OVz92unweowyA=";

  patches = [ ./fix-eka-origin-info.patch ];

  env = {
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
