pkgs:
let
  inherit (pkgs.lib)
    flip
    head
    mapAttrs
    match
    pipe
    recursiveUpdate
    ;

  pname = "tattoy";
  version = "0.1.2";

  src = pkgs.fetchFromGitHub {
    owner = "tattoy-org";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-F8X5qtWm/uFFyPnZ7f3spmJGOepmDo0ITs25mQvC69c=";
  };

  cargo = import ./Cargo.nix {
    inherit pkgs;

    defaultCrateOverrides = pipe ./Cargo.nix [
      (x: (import x { inherit pkgs; }).workspaceMembers)
      (mapAttrs (_: flip pipe [
        (x: toString x.build.src.origSrc)
        (match ".*/(crates/.*)")
        (x: { src = "${src}/${head x}"; })
      ]))
      (flip recursiveUpdate {
        rav1e.env.CARGO_ENCODED_RUSTFLAGS = "";
        shadow-terminal.env.CARGO = "";

        tattoy = {
          preBuild = ''
            sed -i \
              '7i #![feature(const_vec_string_slice)]' \
              src/main.rs
          '';

          env.RUSTC_BOOTSTRAP = "1"; # :3

          buildInputs = with pkgs; [
            xorg.libxcb
          ];
        };
      })
      (mapAttrs (_: x: _: x))
      (flip recursiveUpdate pkgs.defaultCrateOverrides)
    ];
  };
in
cargo.workspaceMembers.${pname}.build.overrideAttrs {
  meta = {
    description = "A text-based compositor for modern terminals";
    homepage = "https://tattoy.sh";
    mainProgram = pname;
  };
}
