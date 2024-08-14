pkgs: pkgs.inputs.lix.packages.${pkgs.system}.default // {
  meta = {
    description = "A modern, delicious implementation of the Nix package manager";
    homepage = "https://lix.systems";
    mainProgram = "nix";
  };
}
