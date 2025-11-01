pkgs:
let src = (builtins.getFlake "github:unmojang/drasl/a365c936edaf24521d2c745bdb0767fd0126026d"); in
src.packages.${pkgs.stdenv.hostPlatform.system}.drasl.overrideAttrs {
  meta = {
    description = "Yggdrasil-compatible API server for Minecraft";
    homepage = "https://github.com/unmojang/drasl";
    mainProgram = "drasl";
  };
}
