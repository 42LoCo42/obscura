pkgs:
let src = builtins.getFlake "github:notashelf/nyxpkgs/a9c2ef2ea7c4b7e5036f7c60108df2bbcfc9a3c4"; in
src.packages.${pkgs.system}.foot-transparent // {
  meta.description = "A patched version of the foot terminal emulator that brings back fullscreen transparency";
  meta.homepage = "https://github.com/NotAShelf/nyxpkgs/blob/main/pkgs/applications/terminal-emulators/foot-transparent/default.nix";
}
