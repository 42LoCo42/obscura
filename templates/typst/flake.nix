{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs.lib) flatten flip hasPrefix mapAttrsToList pipe;
        mal = mapAttrsToList;

        deps = (flip pipe [
          (mal (namespace: mal (pname: mal (version: x: {
            name = "${namespace}/${pname}/${version}";
            path = if hasPrefix "/" x then x else
            pkgs.fetchzip {
              url = "https://packages.typst.org/${namespace}/${pname}-${version}.tar.gz";
              stripRoot = false;
              hash = x;
            };
          }))))
          flatten
          (pkgs.linkFarm "deps")
        ]) {
          # put (namespaced!) packages here

          # example - using the https://packages.typst.org registry
          preview = {
            touying."0.5.5" = "sha256-4hVqQUBo7HKfMVV6GC7zcTY0shxPTPN04BnkD5LxKnE=";
          };

          # example - using a custom package
          local = {
            iu."1.0.0" = (pkgs.fetchFromGitHub {
              owner = "42LoCo42";
              repo = "typkg";
              rev = "376325f4c8bb9d88456b100256d907b0bea9b1c6";
              hash = "sha256-RVWuUiZlM3orswLPg3qOTGZNLOXAAA8l8lJryIy9PNE=";
            }) + /iu/1.0.0;
          };
        };
      in
      rec {
        packages.default = pkgs.writeShellApplication {
          name = "pdf";
          runtimeInputs = with pkgs; [ typst ];
          text = ''
            for i in ./*.typ; do
              typst compile "$i" "''${i%typ}pdf"
            done
          '';
        };

        devShells.default = pkgs.mkShell {
          TYPST_PACKAGE_CACHE_PATH = deps;
          shellHook = "unset SOURCE_DATE_EPOCH";

          packages = with pkgs; [ typst packages.default ];
        };
      });
}
