pkgs: (pkgs.fastfetch.override {
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
}).overrideAttrs (old: {
  meta = old.meta // {
    description = "fastfetch with only the modules I need";
  };
})
