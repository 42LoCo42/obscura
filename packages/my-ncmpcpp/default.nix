pkgs: pkgs.ncmpcpp.overrideAttrs (old: {
  patches = [ ./medialibrary.patch ];

  meta = old.meta // {
    description = "ncmpcpp except the media library always shows Albums - Songs";
  };
})
