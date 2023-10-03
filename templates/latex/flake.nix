{
  description = "pdflatex environment";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        tex-env = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small wrapfig capt-of;
        };
      in
      {
        defaultPackage = pkgs.stdenvNoCC.mkDerivation {
          name = "pdf";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            emacs29-nox
            parallel
            tex-env
          ];

          buildPhase = ''
            parallel \
              env HOME=/build emacs \
                --batch \
                --visit "{}" \
                -f org-latex-export-to-pdf \
              ::: ./*.org
          '';

          installPhase = ''
            mkdir -p $out
            cp ./*.pdf $out
          '';
        };

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            tex-env
          ];
        };
      });
}
