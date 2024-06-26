pkgs:
let
  flake = builtins.getFlake "github:mattwparas/steel/a818390fbbf9beb681b75494a2b1025a5070684e?narHash=sha256-PPNCexmCC7h94atd7INIZcC3Tkc9ftbijxaR2sUzlms%3D";
in
flake.packages.${pkgs.system}.steel.overrideAttrs (old: {
  meta = old.meta // {
    description = "An embedded scheme interpreter in Rust";
    homepage = "https://github.com/mattwparas/steel";
    mainProgram = "steel";
  };
})
