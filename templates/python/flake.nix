{
  inputs = {
    pyproject.url = "github:pyproject-nix/build-system-pkgs";
    pyproject.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { flake-utils, nixpkgs, pyproject, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inherit (pkgs.lib) composeManyExtensions pipe;
        inherit (pkgs.lib.fileset) toSource unions;
        inherit (pyproject.inputs) pyproject-nix uv2nix;

        pname = pipe ./pyproject.toml [
          builtins.readFile
          builtins.fromTOML
          (x: x.project.name)
        ];

        src = toSource {
          root = ./.;
          fileset = unions [
            ./${pname}.py
            ./pyproject.toml
            ./uv.lock
          ];
        };

        workspace = uv2nix.lib.workspace.loadWorkspace {
          workspaceRoot = "${src}";
        };

        overlay = workspace.mkPyprojectOverlay {
          sourcePreference = "wheel";
        };

        pythonSet = (pkgs.callPackage pyproject-nix.build.packages {
          python = pkgs.python312;
        }).overrideScope (composeManyExtensions [
          pyproject.overlays.default
          overlay
        ]);

        venv = pythonSet.mkVirtualEnv pname workspace.deps.default;
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          inherit pname;
          inherit (pythonSet.${pname}) version;
          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            cat << EOF > $out/bin/${pname}
            #!${venv}/bin/python
            import ${pname}
            EOF
            chmod +x $out/bin/${pname}
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ venv uv ];
        };
      });
}
