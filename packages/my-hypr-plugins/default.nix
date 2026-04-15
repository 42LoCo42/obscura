pkgs:
let
  inherit (pkgs.hyprland) version;

  src = pkgs.fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-plugins";
    rev = "3e38db916aaecba0a7c7698c6df0c68acb89f312";
    hash = "sha256-1baTmNmnYJwSKyim7pJoy5s5dYnO3BdU/oZHoJa06sI=";
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
  inherit (pkgs.hyprlandPlugins) hypr-dynamic-cursors;
}).overrideAttrs (old: {
  name = "${old.name}-${version}";

  pname = old.name;
  inherit version;

  meta.description = "All the Hyprland plugins I use";
})
