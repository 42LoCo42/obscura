pkgs: (import (pkgs.fetchzip {
  url = "https://github.com/42LoCo42/what-datetime-is-it-right-now-dot-com/archive/refs/tags/0.2.0.tar.gz";
  hash = "sha256-HTKaXNoP8drHOsfJXLRgExNvi1J8D0//LYdqeJvFoF4=";
}))
{ inherit pkgs; }
