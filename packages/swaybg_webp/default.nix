# we can't just call swaybg with GDK_PIXBUF_MODULE_FILE,
# since it's already wrapped with that, so override that wrapping
# taken from https://github.com/NixOS/nixpkgs/pull/322045
pkgs: pkgs.swaybg.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ (with pkgs; [
    makeBinaryWrapper
    wrapGAppsNoGuiHook
  ]);

  postInstall =
    let
      loaders = pkgs.gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = with pkgs; [
          webp-pixbuf-loader
        ];
      };
    in
    ''
      export GDK_PIXBUF_MODULE_FILE="${loaders}"
    '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapProgram $out/bin/swaybg ''${makeWrapperArgs[@]}
  '';
})
