{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        tex-env = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            capt-of
            scheme-small
            wrapfig
            ;
        };
      in
      rec {
        packages.default = pkgs.writeShellApplication {
          name = "pdf";

          runtimeInputs = with pkgs; [
            emacs29-nox
            parallel
            tex-env
          ];

          text = ''
            parallel emacs                \
              --batch                     \
              --visit "{}"                \
              -f org-latex-export-to-pdf \
              ::: ./*.org
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = [ packages.default ];
        };
      });
}
