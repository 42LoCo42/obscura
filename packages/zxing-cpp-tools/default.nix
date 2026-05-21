pkgs: pkgs.infuse pkgs.kdePackages.zxing-cpp {
  __output = {
    cmakeFlags.__pipe = [
      (pkgs.lib.remove "-DZXING_EXAMPLES=OFF")
      (x: x ++ [ "-DZXING_EXAMPLES=ON" ])
    ];

    nativeBuildInputs.__append = with pkgs; [
      pkg-config
    ];

    buildInputs.__append = with pkgs; [
      stb
    ];

    meta.description.__assign = "zxing-cpp with example reader/writer binaries";
  };
}
