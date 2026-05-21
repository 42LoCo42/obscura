pkgs: pkgs.infuse pkgs.fastfetch {
  __input = pkgs.lib.mapAttrs (_: x: { __assign = x; }) {
    audioSupport = false;
    brightnessSupport = false;
    dbusSupport = false;
    enlightenmentSupport = false;
    gnomeSupport = false;
    imageSupport = false;
    openclSupport = false;
    openglSupport = false;
    terminalSupport = false;
    vulkanSupport = false;
    x11Support = false;
    xfceSupport = false;

    zfsSupport = true;
  };

  __output = {
    meta.description.__assign = "fastfetch with only the modules I need";
  };
}
