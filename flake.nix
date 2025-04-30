{
  description = "A personal collection of unusual things";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs.lib)
        concatLines
        getExe
        mapAttrs'
        mapAttrsToList
        pipe
        recursiveUpdate
        ;

      merge = builtins.foldl' recursiveUpdate { };

      ##########################################

      mkPackages = system:
        let
          dir = ./packages;

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ (_: _: packages) ];
          };

          packages = pipe dir [
            builtins.readDir
            (mapAttrs' (file: _: {
              name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
              value = import "${dir}/${file}" pkgs;
            }))
          ];
        in
        { packages.${system} = packages; };

      allPackages = merge (map mkPackages
        [ "x86_64-linux" "aarch64-linux" ]);

      ##########################################

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      readme = pipe self.packages.${system} [
        (mapAttrsToList (k: v: builtins.replaceStrings [ "\n" ] [ " " ]
          ("|" + builtins.concatStringsSep "|" [
            "`${k}`"
            "`${v.version or "n/a"}`"
            "${v.meta.description or "n/a"}"
            "${v.meta.homepage or "n/a"}"
          ] + "|")))
        (rows: pipe rows [
          concatLines
          (body: pipe ./README.md.in [
            builtins.readFile
            (builtins.replaceStrings
              [ "@NUM@" ] [ (toString (builtins.length rows)) ])
            (head: head + body)
          ])
        ])
      ];

      hashes = pipe self.packages.${system} [
        (mapAttrsToList (k: v: builtins.concatStringsSep " " [
          ''packages.${system}."${k}"''
          (builtins.substring 11 32 v.outPath)
        ]))
        concatLines
        builtins.unsafeDiscardStringContext
      ];
    in
    allPackages // {
      nixosModules."9mount" = import ./packages/9mount/module.nix {
        packages = self.packages;
      };

      templates = let dir = ./templates; in pipe dir [
        builtins.readDir
        builtins.attrNames
        (map (name: {
          inherit name;
          value = {
            description = "${name} template";
            path = "${dir}/${name}";
          };
        }))
        builtins.listToAttrs
      ];

      ##########################################

      inherit readme hashes;

      apps.${system} = (builtins.mapAttrs (_: x: {
        type = "app";
        program = getExe x;
      })) rec {
        default = update;

        update = pkgs.writeShellApplication {
          name = "update";
          text = ''
            cat ${pkgs.writeText "README.md" readme} > README.md
            cat ${pkgs.writeText "hashes"    hashes} > hashes
          '';
        };

        hammer = pkgs.writeShellApplication {
          name = "hammer";
          runtimeInputs = with pkgs; [ jq nixpkgs-hammering parallel ];
          text = pipe self.packages.${pkgs.system} [
            (mapAttrsToList (n: _: n))
            (builtins.concatStringsSep "\n")
            (x: ''
              if [ -n "''${1-}" ]; then
                parallel nix build -L --no-link '.#{}' << EOF
              ${x}
              EOF
              fi

              xargs nixpkgs-hammer -f \
                ${pkgs.writeText "default.nix" ''
                  _: (builtins.getFlake "git+file://''${builtins.getEnv "PWD"}").packages.''${builtins.currentSystem}
                ''} \
              << EOF |& grep -Ev '^error: build log' | less
              ${x}
              EOF
            '')
          ];
        };
      };
    };
}
