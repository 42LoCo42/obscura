pkgs0:
let
  inherit (pkgs0.lib) attrValues pipe;

  pkgs1 = pkgs0.extend (_: prev: {
    hyprland = prev.hyprland.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        # disable LTO
        (prev.fetchpatch {
          url = "https://github.com/hyprwm/Hyprland/commit/ed936430216e7aa5f6f53d22eff713f8e9ed69ac.patch";
          hash = "sha256-5dX/n9Pj4q3EAdbAEcNW1LlSFeAVStnp0KKvOtSxUDM=";
        })

        # fix Debug::log race condition
        (prev.fetchpatch {
          url = "https://github.com/hyprwm/Hyprland/commit/cfac27251af5df4352f747c4539ea9f65450f05a.patch";
          hash = "sha256-b6XP4X9bQps7YSzFHTSPVx2rtEYI85EUgCw+yENHJkQ=";
        })
      ];
    });
  });
in
(pipe {
  inherit (pkgs1) hyprland xdg-desktop-portal-hyprland;
  inherit (pkgs1.hyprlandPlugins) hypr-dynamic-cursors hyprwinwrap;

  hyprfocus = pkgs1.hyprlandPlugins.hyprfocus.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./hyprfocus-fullscreen.patch ];
  });
}) [
  attrValues
  (map (x: { name = x.pname; path = x; }))
  (pkgs0.linkFarm "hyprland-patched")
  (x: x.overrideAttrs {
    inherit (pkgs1.hyprland) version;

    meta = {
      description = "Hyprland with LTO and Debug::log race fixes applied";
      inherit (pkgs1.hyprland.meta) homepage;
    };
  })
]
