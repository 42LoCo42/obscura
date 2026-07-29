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
      version.__assign = "0-unstable-2026-07-21";

      src.__output = {
        rev.__assign = "f5ba36c7622098b53bf62ddb8ddf03b914abbdf8";
        hash.__assign = "sha256-HKzJtEkafkWjTx35spDp6pm1oClN7vIipJ2wwU4ocNY=";
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
