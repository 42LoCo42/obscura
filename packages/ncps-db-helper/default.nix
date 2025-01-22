pkgs: pkgs.writeShellApplication rec {
  name = "ncps-db-helper";

  runtimeInputs = with pkgs; [ coreutils dbmate ];
  text = pkgs.lib.pipe ./main.sh [
    builtins.readFile
    (builtins.replaceStrings [ "@bin@" "@mgr@" ] [
      (pkgs.lib.getExe pkgs.ncps)
      "${pkgs.ncps}/share/ncps/db/migrations"
    ])
  ];

  meta = {
    description = "Wrap ncps with automatic database creation";
    mainProgram = name;
  };
}
