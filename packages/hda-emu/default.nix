pkgs: pkgs.stdenv.mkDerivation (drv: {
  pname = "hda-emu";
  version = "0.2.6-unstable-2026-06-04";

  src = pkgs.fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/hda-emu.git/snapshot/hda-emu-9c83d88e4510bee07ec1d940323b385ec60f60cc.tar.gz";
    hash = "sha256-q4B1iizv1EpLjFHH9bBQzX040Jq59Ugce8W5+y5ZAsA=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
  ];

  configureFlags = [
    "--with-kerneldir=linux-${pkgs.linux.version}"
  ];

  postPatch = ''
    # fix redefinition of struct stat
    : > include/linux/stat.h

    # define numeric types to fix aarch64 build
    cat << EOF > types.h
    #include <stdint.h>
    typedef uint8_t __u8;
    typedef uint16_t __u16;
    typedef uint32_t __u32;
    typedef long long unsigned int __u64;
    EOF

    # include numeric types
    sed -i '1i#include "types.h"' hda-{emu,log}.c

    echo 'Unpacking kernel...'
    tar xf ${pkgs.linux.src}
  '';

  enableParallelBuilding = true;

  meta = {
    description = "ALSA HD-audio driver debugging & testing tool";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/hda-emu.git";
    mainProgram = drv.pname;
  };
})
