# TODO https://pr-tracker.bunny/?pr=502133
# there's not even a PR for 2.19.0 yet ōnō
pkgs: pkgs.infuse pkgs.ergochat {
  __output = {
    version.__assign = "2.19.0";

    src.__output.hash.__assign = "sha256-/SsPfWqCdHa2tvkVEN95cF9pxzHr/Kzt3qVKHEZjZMc=";

    tags.__append = [
      "i18n"
      "postgresql"
    ];
  };
}
