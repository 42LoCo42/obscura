# TODO https://github.com/antonWetzel/prettypst/issues/11
pkgs: pkgs.infuse pkgs.prettypst {
  __output = {
    patches.__append = [
      ./hline.patch
    ];
  };
}
