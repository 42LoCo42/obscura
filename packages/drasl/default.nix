pkgs:
let src = (builtins.getFlake "github:unmojang/drasl/f8eb5da15a1877373a4dd3b68787fd6428003261"); in
src.packages.${pkgs.system}.drasl.overrideAttrs {
  meta = {
    description = "Yggdrasil-compatible API server for Minecraft";
    homepage = "https://github.com/unmojang/drasl";
    mainProgram = "drasl";
  };
}
