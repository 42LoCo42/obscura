{
  inputs = {
    pyproject.url = "pyproject-nix/build-system-pkgs";
    pyproject.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { flake-utils, nixpkgs, pyproject, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inherit (pkgs.lib) composeManyExtensions;
        inherit (pkgs.lib.fileset) toSource unions;
        inherit (pyproject.inputs) pyproject-nix uv2nix;

        pname = "example";

        src = toSource {
          root = ./.;
          fileset = unions [
            ./main.py
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
        packages.default = pythonSet.${pname};

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ venv uv ];
        };
      });
}
