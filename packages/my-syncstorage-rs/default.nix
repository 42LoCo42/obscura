# TODO https://github.com/NixOS/nixpkgs/pull/484932

pkgs: (pkgs.syncstorage-rs.override {
  dbBackend = "postgresql";
}).overrideAttrs (new: old: {
  version = "0.23.3";

  src = pkgs.fetchFromGitHub {
    inherit (old.src) owner repo;
    tag = new.version;
    hash = "sha256-d0rA/bWuo4gXvqI2inlvRI9NBP6ZRNSwLPkszNIkmhE=";
  };

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit (new) src;
    hash = "sha256-BJ5+6o57WlwsTerKCmOPXATPHQfjr5cRYMbqC8CIPg0=";
  };
})
