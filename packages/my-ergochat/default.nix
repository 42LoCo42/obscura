# TODO https://pr-tracker.bunny/?pr=502133
pkgs: pkgs.infuse pkgs.ergochat {
  __output = {
    version.__assign = "2.18.0";

    src.__output.hash.__assign = "sha256-6aibQ4dq3zkRoeLLrAc3OXXQWRZIQ7mPMSnWhz8LJsM=";

    tags.__append = [
      "i18n"
      "postgresql"
    ];
  };
}
