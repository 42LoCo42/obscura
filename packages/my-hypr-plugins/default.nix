pkgs:
let
  inherit (pkgs.hyprland) version;
  plugins = pkgs.hyprlandPlugins;

  src = pkgs.fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-plugins";
    rev = "eaf18d55d51cef00818c5a4fdd4170f8cc2de4dc";
    hash = "sha256-d2wOUZlOqGAW9mwlpq7c/YlneW2ZDJt9d/2bq7mnKdM=";
  };

  build = pluginName: plugins.mkHyprlandPlugin {
    inherit pluginName version src;
    sourceRoot = "${src.name}/${pluginName}";

    nativeBuildInputs = with pkgs; [
      meson
      ninja
    ];

    meta = { };
  };
in
(pkgs.linkFarm "my-hypr-plugins" {
  hyprfocus = build "hyprfocus";
  hyprwinwrap = build "hyprwinwrap";

  hypr-dynamic-cursors = pkgs.infuse plugins.hypr-dynamic-cursors {
    __output = {
      version.__assign = "0-unstable-2026-03-12";

      src.__output = {
        rev.__assign = "47f3da0dc5d97f51c2307070fd1d547efbdae6a3";
        hash.__assign = "sha256-LATqyui3+kV7MJG07E2OsWbnv7BLHwmHS0aYW7r9dAI=";
      };

      enableParallelBuilding.__assign = true;
    };
  };
}).overrideAttrs (old: {
  name = "${old.name}-${version}";

  pname = old.name;
  inherit version;

  meta.description = "All the Hyprland plugins I use";
})
