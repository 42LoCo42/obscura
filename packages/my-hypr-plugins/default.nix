pkgs:
let
  inherit (pkgs.hyprland) version;
  plugins = pkgs.hyprlandPlugins;
in
(pkgs.linkFarm "my-hypr-plugins" {
  inherit (plugins) hyprfocus;

  hyprwinwrap = plugins.mkHyprlandPlugin (drv: {
    pluginName = "hyprwinwrap";
    version = "0.56";

    src = pkgs.fetchFromGitHub {
      owner = "gen3vra";
      repo = drv.pname;
      tag = drv.version;
      hash = "sha256-9MdwossojhQccorcZcPxi+xaNOYGESZ0B3N6T/tNnzI=";
    };

    nativeBuildInputs = with pkgs; [
      meson
      ninja
    ];

    meta = {
      description = "Display any window as a wallpaper in Hyprland";
      homepage = "https://github.com/gen3vra/hyprwinwrap";
    };
  });

  hypr-dynamic-cursors = pkgs.infuse plugins.hypr-dynamic-cursors {
    __output = {
      version.__assign = "0-unstable-2026-08-06";

      src.__output = {
        rev.__assign = "5a224284872208b5324759d535d65061043725de";
        hash.__assign = "sha256-BQjuQplkQFA30/7evDxmEAvr2ArIG09JffEBQhuzo80=";
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
