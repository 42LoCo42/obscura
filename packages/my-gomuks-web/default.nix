pkgs: pkgs.infuse pkgs.gomuks-web {
  __output.patches.__append = [
    ./call-button.patch
    ./formatting-keybinds.patch
    ./sso.patch
  ];
}
