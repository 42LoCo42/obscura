pkgs: pkgs.lix.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    # don't filter ANSI escape sequences in help output
    ./0001-fix-help-links.patch
  ];

  # for some reason, this breaks on GitHub Actions...
  doInstallCheck = false;
})
