pkgs: (import (fetchTarball {
  url = "https://github.com/42LoCo42/what-datetime-is-it-right-now-dot-com/archive/refs/tags/0.2.2.tar.gz";
  sha256 = "sha256-6/9Na4f7h5xPZjWVcVAx6zd810Q1VsK3BDrFY5kjQw4=";
})) { inherit pkgs; }
