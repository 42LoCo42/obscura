pkgs:
let
  pin = pkgs.multiverse.at (pkgs.multiverse.revOf "hyprland" "0.56.2");
  inherit (pin) hyprland hyprlandPlugins;
  inherit (hyprland) version;
  pname = "my-hypr-plugins";
in
(pkgs.infuse (pkgs.linkFarm "${pname}-${version}" {
  # NOTE hyprfocus is already available for 0.57.0
  inherit (hyprlandPlugins) hyprfocus;

  # TODO needs release for 0.57.0
  hyprwinwrap = hyprlandPlugins.mkHyprlandPlugin (drv: {
    pluginName = "hyprwinwrap";
    version = "0.56v2";

    src = pkgs.fetchFromGitHub {
      owner = "gen3vra";
      repo = drv.pname;
      tag = drv.version;
      hash = "sha256-mQ5D59pM5r8n8bSMg4Kmhl+LioRTEfoow6mRoj+k7LA=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = with pkgs; [
      meson
      ninja
    ];

    patchPhase = ''
      sed -i "/^globber/d; s|^src.*|src = ['main.cpp']|" meson.build
    '';

    meta = {
      description = "Display any window as a wallpaper in Hyprland";
      homepage = "https://github.com/gen3vra/hyprwinwrap";
    };
  });

  # TODO upgrade
  hypr-dynamic-cursors = pkgs.infuse hyprlandPlugins.hypr-dynamic-cursors {
    __output = {
      version.__assign = "0-unstable-2026-08-06";

      src.__output = {
        rev.__assign = "5a224284872208b5324759d535d65061043725de";
        hash.__assign = "sha256-BQjuQplkQFA30/7evDxmEAvr2ArIG09JffEBQhuzo80=";
      };

      enableParallelBuilding.__assign = true;
    };
  };
})) {
  __output = {
    pname.__assign = pname;
    version.__assign = version;

    passthru.__merge = { inherit hyprland; };

    meta.description.__assign = "All the Hyprland plugins I use";
  };
}
