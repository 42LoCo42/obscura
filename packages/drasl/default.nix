pkgs:
let src = (builtins.getFlake "github:unmojang/drasl/c3cb43885f78260c80a1dde211f075a3a2017cd3"); in
src.packages.${pkgs.system}.drasl.overrideAttrs {
  version = "3.1.1-unstable-2025-07-27";
  __intentionallyOverridingVersion = true;

  meta = {
    description = "Yggdrasil-compatible API server for Minecraft";
    homepage = "https://github.com/unmojang/drasl";
    mainProgram = "drasl";
  };
}
