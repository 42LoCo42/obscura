pkgs:
let
  pname = "bun2nix";
  version = "2.1.2";

  src = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    tag = version;

    postFetch = ''
      rm -rfv $out/nix/dev/{devshell,formatter}.nix

      cat << EOF > $out/nix/dev/systems.nix
      { systems = [ "x86_64-linux" "aarch64-linux" ]; }
      EOF
    '';

    hash = "sha256-fNBobEJh+qg7wfxptav6tP1AZOQGlST+lLVXY0wPNIU=";
  };

  inherit (pkgs.stdenv) system;

  inputs = {
    self = {
      outPath = src;
      inherit inputs;
    } // outputs;

    inherit (pkgs) flake-parts;

    nixpkgs = {
      _type = "flake";
      outPath = "";
      legacyPackages.${system} = pkgs // {
        stdenvNoCC = pkgs.stdenv;
      };
    };
  };

  outputs = (import "${src}/flake.nix").outputs inputs;
  packages = outputs.packages.${system};
in
pkgs.infuse packages.bun2nix {
  __output = {
    postInstall.__append = ''
      mkdir -p $out/libexec
      ln -s ${packages.cacheEntryCreator}/bin/cache_entry_creator $out/libexec
    '';
  };
}
