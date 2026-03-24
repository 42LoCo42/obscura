pkgs: pkgs.rustPlatform.buildRustPackage (drv: {
  pname = "direnv-instant";
  version = "1.1.0-unstable-2026-03-22";

  src = import ./source.nix;

  cargoHash = "sha256-WDTOqbYEyjTMhH33JHeZLIeGR1av0atNjIltMNmXcoI=";

  meta = {
    description = "Non-blocking direnv integration daemon with tmux support";
    homepage = "https://github.com/Mic92/direnv-instant";
    mainProgram = drv.pname;
  };
})
