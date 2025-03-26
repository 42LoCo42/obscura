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
              rev = "6d10f256eaa0624a9c149f16bc00d7ce5c0840d8";
              hash = "sha256-3MLXOjxaBxubqrxIkib6Sf4Iud8zctPU6OT5jc4cFTw=";
            }) + /iu/1.0.0;
          };
        };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "pdf";
          src = ./.;

          SOURCE_DATE_EPOCH = 1742943600 + 3600; # 2025-03-26
          TYPST_PACKAGE_CACHE_PATH = deps;
          TYPST_FONT_PATHS = builtins.concatStringsSep ":" (with pkgs; [
            liberation_ttf
          ]);

          nativeBuildInputs = with pkgs; [ typst ];

          installPhase = ''
            mkdir $out
            for i in ./*.typ; do
              typst compile "$i" "$out/''${i%typ}pdf"
            done
          '';
        };
      });
}
