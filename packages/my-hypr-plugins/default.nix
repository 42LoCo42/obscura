pkgs:
let
  inherit (pkgs.hyprland) version;

  src = pkgs.fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-plugins";
    rev = "eaf18d55d51cef00818c5a4fdd4170f8cc2de4dc";
    hash = "sha256-d2wOUZlOqGAW9mwlpq7c/YlneW2ZDJt9d/2bq7mnKdM=";
  };

  build = pluginName: pkgs.hyprlandPlugins.mkHyprlandPlugin {
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

  hypr-dynamic-cursors = pkgs.hyprlandPlugins.hypr-dynamic-cursors.overrideAttrs (old: {
    version = "0-unstable-2026-03-12";

    src = pkgs.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "47f3da0dc5d97f51c2307070fd1d547efbdae6a3";
      hash = "sha256-LATqyui3+kV7MJG07E2OsWbnv7BLHwmHS0aYW7r9dAI=";
    };

    enableParallelBuilding = true;
  });
}).overrideAttrs (old: {
  name = "${old.name}-${version}";

  pname = old.name;
  inherit version;

  meta.description = "All the Hyprland plugins I use";
})
