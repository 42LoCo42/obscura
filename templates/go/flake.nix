{
  description = "Example go flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mkApps = (names: builtins.listToAttrs (map
          (name: {
            inherit name;
            value = flake-utils.lib.mkApp {
              drv = self.defaultPackage.${system};
              exePath = "/bin/${name}";
            };
          })
          names));
      in
      {
        defaultPackage = pkgs.buildGoModule {
          pname = "example";
          version = "0.0.1";
          src = ./.;

          vendorSha256 = pkgs.lib.fakeSha256;

          nativeBuildInputs = with pkgs; [
            pkg-config
            # libsodium.dev
          ];

          # PKG_CONFIG_PATH = "${pkgs.libsodium.dev}/lib/pkgconfig";
        };

        apps = mkApps [
          "example-binary-name"
        ];

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            go
            gopls
          ];
        };
      });
}
