{ foot }: foot.overrideAttrs (prev: {
  mesonFlags = prev.mesonFlags ++ [ "-Dfullscreen_alpha=true" ];
  mainProgram = "foot";
  patches = (prev.patches or [ ]) ++ [ ./foot-transparent.patch ];
})
