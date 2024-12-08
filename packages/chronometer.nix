pkgs:
let src = builtins.getFlake "github:42loco42/chronometer/dd49f3b7ec73fe7aeb790eb10b008232dfbc2466"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = {
    description = "The Chronometer of Endless Whimsy!";
    homepage = "https://github.com/42LoCo42/chronometer";
  };
})
