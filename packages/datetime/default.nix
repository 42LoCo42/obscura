pkgs: (import (pkgs.fetchzip {
  url = "https://github.com/42LoCo42/what-datetime-is-it-right-now-dot-com/archive/refs/tags/0.2.1.tar.gz";
  hash = "sha256-N2hlTvPOp+GPUeLGn5ZjuWklHuHxrzkPUhZiIwt/aEU=";
}))
{ inherit pkgs; }
