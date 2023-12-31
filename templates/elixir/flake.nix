{
  description = "Example Elixir flake";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        defaultPackage = pkgs.beamPackages.mixRelease {
          pname = "example";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            elixir_1_15
          ];
        };

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            beamPackages.hex
            elixir-ls
            elixir_1_15
          ];
        };
      });
}
