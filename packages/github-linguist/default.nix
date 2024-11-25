pkgs:
let
  raw = pkgs.bundlerApp rec {
    pname = "github-linguist";

    gemdir = ./.;
    exes = [ pname ];

    meta = {
      description = "Tool used by GitHub to detect repository languages";
      homepage = "https://github.com/github-linguist/linguist";
      mainProgram = pname;
    };
  };
in
raw // { version = raw.gems.${raw.meta.mainProgram}.suffix; }
