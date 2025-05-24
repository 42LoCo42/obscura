pkgs: pkgs.foot.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    # https://codeberg.org/fazzi/foot/commit/492b9abd2c6b7215f191fd658c3945772e0f0499
    ./0001-always-enable-transparent_fullscreen.patch
  ];

  meta = {
    description = "A patched version of the foot terminal emulator that brings back fullscreen transparency";
    homepage = "https://codeberg.org/fazzi/foot";
  };
})
