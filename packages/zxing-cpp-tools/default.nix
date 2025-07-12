pkgs:
let inherit (pkgs.lib) pipe remove; in
pkgs.kdePackages.zxing-cpp.overrideAttrs (old: {
  cmakeFlags = pipe (old.cmakeFlags or [ ]) [
    (remove "-DZXING_EXAMPLES=OFF")
    (x: x ++ [ "-DZXING_EXAMPLES=ON" ])
  ];

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ (with pkgs; [
    pkg-config
  ]);

  buildInputs = (old.buildInputs or [ ]) ++ (with pkgs; [
    stb
  ]);

  meta = {
    description = "zxing-cpp with example reader/writer binaries";
    inherit (old.meta) homepage;
  };
})
