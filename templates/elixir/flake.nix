{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in rec {
        packages.default = pkgs.beamPackages.mixRelease {
          pname = "example";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            elixir_1_15
          ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            beamPackages.hex
            elixir-ls
          ];
        };
      });
}
