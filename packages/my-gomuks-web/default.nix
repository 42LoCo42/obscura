pkgs: pkgs.infuse pkgs.gomuks-web {
  __output.patches.__append = [
    ./sso.patch
  ];
}
