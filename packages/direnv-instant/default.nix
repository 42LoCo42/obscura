pkgs:
let
  src = pkgs.fetchFromGitHub {
    owner = "Mic92";
    repo = "direnv-instant";
    rev = "fc2eb8e6ac541d24266ad0016fdbd306c8420660";
    hash = "sha256-Ufnl7F9RLoFkWpcNY72jUH+K3p9FUfnlyJXeABFholw=";
  };

  pkg = (pkgs.callPackage src { }).overrideAttrs (old: {
    version = "1.1.0-unstable-2026-03-10";
    __intentionallyOverridingVersion = true;

    passthru = {
      module = hm: {
        imports = [ "${src}/home.nix" ];
        programs.direnv-instant.package = pkg;
      };
    };

    meta = old.meta // {
      homepage = "https://github.com/Mic92/direnv-instant";
    };
  });
in
pkg
