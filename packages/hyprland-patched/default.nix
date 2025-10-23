pkgs0:
let
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
(pkgs0.linkFarm "hyprland-patched" (with pkgs1; [
  { name = "hyprland"; /****************/ path = hyprland; }
  { name = "hypr-dynamic-cursors"; /****/ path = hyprlandPlugins.hypr-dynamic-cursors; }
  { name = "hyprfocus"; /***************/ path = hyprlandPlugins.hyprfocus; }
  { name = "hyprwinwrap"; /*************/ path = hyprlandPlugins.hyprwinwrap; }
  { name = "xdg-desktop-portal-hyprland"; path = xdg-desktop-portal-hyprland; }
])).overrideAttrs {
  inherit (pkgs1.hyprland) version;

  meta = {
    description = "Hyprland with LTO and Debug::log race fixes applied";
    inherit (pkgs1.hyprland.meta) homepage;
  };
}
