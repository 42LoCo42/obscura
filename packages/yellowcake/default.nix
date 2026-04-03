pkgs: pkgs.buildDotnetModule (drv: {
  pname = "yellowcake";
  version = "1.2.13.0";

  src = pkgs.fetchFromGitHub {
    owner = "NaghDiefallah";
    repo = drv.pname;
    tag = "v${drv.version}";
    hash = "sha256-JZ4lp6FvyIG1FP4lNI9mHlQNuk1Hw5xTgZZC/ZvUehY=";
  };

  prePatch = ''
    grep -Rl AppContext.BaseDirectory \
    | xargs sed -i 's|AppContext.BaseDirectory|Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Yellowcake")|g'

    sed -i '/startup.log/d' Program.cs
  '';

  projectFile = "Yellowcake.csproj";
  nugetDeps = ./deps.json;

  selfContainedBuild = true;
  dotnetBuildFlags = [ "/p:AssemblyVersion=${drv.version}" ];

  dotnet-sdk = pkgs.dotnetCorePackages.sdk_10_0;
  dotnet-runtime = pkgs.dotnetCorePackages.runtime_10_0;

  postFixup = ''
    mv $out/bin/{Yellowcake,${drv.pname}}
  '';

  meta = {
    description = "Modern, cross-platform mod manager for Nuclear Option";
    homepage = "https://github.com/NaghDiefallah/Yellowcake";
    mainProgram = drv.pname;
  };
})
