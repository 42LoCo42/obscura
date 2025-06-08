{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs.lib.fileset) toSource unions;
      in
      rec {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "example";
          version = "0.0.1";

          src = toSource {
            root = ./.;
            fileset = unions [
              ./index.html
              ./main.ts
              ./package.json
              ./pnpm-lock.yaml
              ./tsconfig.json
              ./vite.config.ts
            ];
          };

          nativeBuildInputs = with pkgs; [
            nodejs
            pnpm.configHook
          ];

          pnpmDeps = pkgs.pnpm.fetchDeps {
            inherit pname version src;
            hash = "";
          };

          buildPhase = "pnpm build";
          installPhase = "cp -r dist $out";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
        };
      }
    );
}
