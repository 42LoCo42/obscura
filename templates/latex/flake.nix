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
      {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
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

        devShells.default = pkgs.mkShell {
          packages = [ tex-env ];
        };
      });
}
