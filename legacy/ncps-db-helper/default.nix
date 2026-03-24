pkgs:
let
  inherit (pkgs.lib)
    getExe
    pipe
    readFile
    replaceStrings
    ;

  ncps = pkgs.ncps.overrideAttrs {
    # TODO https://hydra.nixos.org/job/nixpkgs/trunk/ncps.aarch64-linux
    doCheck = !pkgs.stdenv.hostPlatform.isAarch64;
  };
in
pkgs.writeShellApplication rec {
  name = "ncps-db-helper";

  runtimeInputs = with pkgs; [ coreutils dbmate ];

  text = pipe ./main.sh [
    readFile
    (replaceStrings [ "@bin@" "@mgr@" ] [
      (getExe ncps)
      "${ncps}/share/ncps/db/migrations"
    ])
  ];

  meta = {
    description = "Wrap ncps with automatic database creation";
    mainProgram = name;
  };
}
