{
  stdenv,
  lib,
  fetchzip,
}: let
  version = "2.13.0";
  src = fetchzip {
    url = "https://github.com/SpecterOps/SharpHound/releases/download/v2.13.0/SharpHound_v2.13.0_windows_x86.zip";
    hash = "sha256-6JLX13gYEFKOu0SzkWFdQfqfO4uVNz7aAS5EUjyvWBA=";
    stripRoot = false;
  };
in
  stdenv.mkDerivation {
    pname = "sharphound";
    inherit version;

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    passthru.prebuilt = true;

    installPhase = ''
      mkdir -p $out/arsenal/active_directory
      cp ${src}/SharpHound.exe $out/arsenal/active_directory/SharpHound.exe
      cp ${src}/SharpHound.exe.config $out/arsenal/active_directory/SharpHound.exe.config
      cp ${src}/SharpHound.pdb $out/arsenal/active_directory/SharpHound.pdb
      cp ${src}/SharpHound.ps1 $out/arsenal/active_directory/SharpHound.ps1
      # cp ${src}/System.Console.dll $out/arsenal/active_directory/System.Console.dll
      # cp ${src}/System.Diagnostics.Tracing.dll $out/arsenal/active_directory/System.Diagnostics.Tracing.dll
      # cp ${src}/System.Net.Http.dll $out/arsenal/active_directory/System.Net.Http.dll
    '';

    meta = with lib; {
      description = "BloodHound data collector for Active Directory";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  }
