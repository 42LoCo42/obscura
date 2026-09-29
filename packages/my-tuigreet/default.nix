pkgs: pkgs.infuse pkgs.tuigreet {
  __output.patches.__append = [
    ./hide-cursor.patch
  ];
}
