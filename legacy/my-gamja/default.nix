# TODO https://codeberg.org/emersion/gamja/pulls/210
pkgs: pkgs.infuse pkgs.gamja {
  __output = {
    patches.__append = [
      (pkgs.fetchpatch {
        url = "https://codeberg.org/emersion/gamja/pulls/210.diff";
        hash = "sha256-ZMiJbwHsHhmYCQko6BWHQU9ck/3pc3mJTyVQVLze76s=";
      })
    ];
  };
}
