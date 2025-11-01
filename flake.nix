{
  description = "A personal collection of unusual things";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (builtins)
        readDir
        toJSON
        unsafeDiscardStringContext
        ;

      inherit (nixpkgs.lib)
        attrNames
        concatLines
        concatStringsSep
        filterAttrs
        flip
        foldl'
        getExe
        length
        listToAttrs
        mapAttrs
        mapAttrs'
        mapAttrsToList
        pipe
        readFile
        recursiveUpdate
        replaceStrings
        substring
        ;

      merge = foldl' recursiveUpdate { };

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
            readDir
            (mapAttrs' (file: _: {
              name = replaceStrings [ ".nix" ] [ "" ] file;
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
        (mapAttrsToList (k: v: replaceStrings [ "\n" ] [ " " ]
          ("|" + concatStringsSep "|" [
            "`${k}`"
            "`${v.version or "n/a"}`"
            "${v.meta.description or "n/a"}"
            "${v.meta.homepage or "n/a"}"
          ] + "|")))
        (rows: pipe rows [
          concatLines
          (body: pipe ./README.md.in [
            readFile
            (replaceStrings
              [ "@NUM@" ] [ (toString (length rows)) ])
            (head: head + body)
          ])
        ])
        (pkgs.writeText "README.md")
      ];

      hashes = pipe self.packages [
        (mapAttrs (_: flip pipe [
          (filterAttrs (_: x: !x.meta.broken))
          (mapAttrs (_: x: substring 11 32 x.outPath))
        ]))
        toJSON
        unsafeDiscardStringContext
        (x: pkgs.runCommand "hashes" { } ''
          ${getExe pkgs.jq} <<\EOF > $out
          ${x}
          EOF
        '')
      ];
    in
    allPackages // {
      nixosModules = {
        "9mount" = import ./packages/9mount/module.nix {
          packages = self.packages;
        };

        lanzaboote = concatStringsSep "" [
          (import ./packages/lanzaboote/source.nix)
          "/nix/modules/lanzaboote.nix"
        ];
      };

      templates = let dir = ./templates; in pipe dir [
        readDir
        attrNames
        (map (name: {
          inherit name;
          value = {
            description = "${name} template";
            path = "${dir}/${name}";
          };
        }))
        listToAttrs
      ];

      ##########################################

      inherit readme hashes;

      apps.${system} = (mapAttrs (_: x: {
        type = "app";
        program = getExe x;
      })) rec {
        default = update;

        update = pkgs.writeShellApplication {
          name = "update";
          text = ''
            cat ${readme} > README.md
            cat ${hashes} > hashes.json
          '';
        };

        hammer = pkgs.writeShellApplication {
          name = "hammer";
          runtimeInputs = with pkgs; [ jq nixpkgs-hammering parallel ];
          text = pipe self.packages.${pkgs.stdenv.hostPlatform.system} [
            (mapAttrsToList (n: _: n))
            (concatStringsSep "\n")
            (x: ''
              if [ -n "''${1-}" ]; then
                parallel nix build -L --no-link '.#{}' << EOF
              ${x}
              EOF
              fi

              xargs nixpkgs-hammer -f \
                ${pkgs.writeText "default.nix" ''
                  _: (getFlake "git+file://''${getEnv "PWD"}").packages.''${currentSystem}
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
