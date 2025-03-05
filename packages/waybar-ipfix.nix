# TODO https://github.com/Alexays/Waybar/pull/3959
pkgs: pkgs.waybar.overrideAttrs (old: {
  src = pkgs.fetchFromGitHub {
    inherit (old.src) owner repo;
    rev = "5e4dac1c0aebd6c4ad1f358f09e1cfd06a95d529";
    hash = "sha256-W5LLXmz3l7DIDC1A9eQiexXpEWumrrnqbfWsfgFWMXM=";
  };
})
