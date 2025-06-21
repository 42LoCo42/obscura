pkgs:
let
  patches = (pkgs.fetchFromGitHub {
    owner = "BoyOrigin";
    repo = "glfw-wayland";
    tag = "2024-03-07";
    hash = "sha256-kvWP34rOD4HSTvnKb33nvVquTGZoqP8/l+8XQ0h3b7Y=";
  }) + /patches;
in
pkgs.glfw3-minecraft.overrideAttrs (old: {
  patches = old.patches ++ [
    "${patches}/0001-Key-Modifiers-Fix.patch"
    "${patches}/0002-Fix-duplicate-pointer-scroll-events.patch"
    "${patches}/0004-Fix-Window-size-on-unset-fullscreen.patch"
    "${patches}/0005-Avoid-error-on-startup.patch"
  ];

  meta = {
    description = "A GLFW Fork that runs on Wayland Natively over X11 with more compatible features just to play Minecraft";
    homepage = "https://github.com/BoyOrigin/glfw-wayland";
  };
})
