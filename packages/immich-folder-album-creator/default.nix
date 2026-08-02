pkgs:
let
  inherit (pkgs.lib) getExe;
  py = pkgs.python3.pkgs;

  pystatx = py.buildPythonPackage (drv: {
    pname = "pystatx";
    version = "0.1-unstable-2026-03-10";

    src = pkgs.fetchFromGitHub {
      owner = "ckaraneen";
      repo = drv.pname;
      rev = "dc014b8e623b8355c48651aa96801a2eb0f3fed9";
      hash = "sha256-/5Lc+rhkEXx+6Z6BZ88UyLvfScnAj2nx6NBQRnsetNs=";
    };

    pyproject = true;

    build-system = with py; [
      setuptools
    ];
  });

  immichpy = py.buildPythonPackage (drv: {
    pname = "immichpy";
    version = "7.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "timonrieger";
      repo = drv.pname;
      tag = "v${drv.version}";
      hash = "sha256-S94RWCKpXghxCPUdRiKPn4zbhez+Jgj/o/mH4fhOtJo=";
    };

    patchPhase = ''
      substituteInPlace pyproject.toml \
        --replace-fail "uv_build==0.11.25" "uv_build>=0.11.25"
    '';

    pyproject = true;

    build-system = with py; [
      uv-build
    ];

    dependencies = with py; [
      aiohttp
      aiohttp-retry
      pydantic
      pystatx
      python-dateutil
      rich
      tenacity
      typing-extensions
    ];
  });

  python = pkgs.python3.withPackages (p: with p; [
    aiohttp
    immichpy
    pyaml
    regex
  ]);
in
pkgs.stdenv.mkDerivation rec {
  pname = "immich-folder-album-creator";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "Salvoxia";
    repo = pname;
    tag = version;
    hash = "sha256-afIWumzo+SKQKcFdw9DgLgqE452ZA2e5XpICgX+eCCU=";
  };

  buildPhase = ''
    sed -i '1i#!${getExe python}' immich_auto_album.py
  '';

  installPhase = ''
    install -Dm755 immich_auto_album.py $out/bin/${pname}
  '';

  meta = {
    description = " Automatically create and populate albums in Immich from a folder structure in external libraries";
    homepage = "https://github.com/Salvoxia/immich-folder-album-creator";
    mainProgram = pname;
  };
}
