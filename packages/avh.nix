pkgs:
let src = builtins.getFlake "github:42loco42/avh/06ddda68e5cd7ff3b6ff1bddf0c3be86caf6a0b6"; in
src.packages.${pkgs.system}.default.overrideAttrs (old: {
  meta = old.meta // {
    description = "AvH video storage";
    homepage = "https://github.com/42LoCo42/avh";
  };
})
