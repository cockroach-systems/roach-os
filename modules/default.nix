{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roachos;
  custom-packages = import ../packages {
    inherit pkgs;
    binaryServer = cfg.binaryServer;
    allowPrebuilt = cfg.allowPrebuilt;
  };
in {
  options.roachos = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user for group memberships (wireshark, docker, etc.)";
    };

    binaryServer = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8080";
      description = "HTTP server hosting pre-built binaries (for tools without public releases, e.g. rubeus)";
    };

    allowPrebuilt = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow packages that fetch pre-compiled binaries. Set to false to only use source-built and script packages.";
    };

    tools = {
      all.enable = lib.mkEnableOption "all offensive security tools";
      cracking.enable = lib.mkEnableOption "password cracking tools (hydra, john, hashcat)";
      networking.enable = lib.mkEnableOption "network tools (netcat, socat, wireshark)";
      web-application.enable = lib.mkEnableOption "web application testing tools (burpsuite, ffuf)";
      database-clients.enable = lib.mkEnableOption "database client tools";
      remote-enumeration.enable = lib.mkEnableOption "remote enumeration tools (nmap, netexec)";
      communication.enable = lib.mkEnableOption "email and messaging tools";
      remote-access.enable = lib.mkEnableOption "remote access tools (rdp, vnc, winrm)";
      exploitation.enable = lib.mkEnableOption "exploitation tools (metasploit, exploitdb)";
      active-directory.enable = lib.mkEnableOption "active directory tools (kerbrute, impacket, responder)";
      programming.enable = lib.mkEnableOption "programming languages for exploit dev";
      office-tools.enable = lib.mkEnableOption "office tools (libreoffice)";
      custom-packages.enable = lib.mkEnableOption "roachos custom tool packages (arsenal, seclists, etc.)";
      nix-shells.enable = lib.mkEnableOption "nix-shell environments (python, python2)";
      other.enable = lib.mkEnableOption "miscellaneous tools";
    };

    services = {
      sliver.enable = lib.mkEnableOption "Sliver C2 server";
      bloodhound.enable = lib.mkEnableOption "BloodHound Community Edition (docker)";
    };
  };

  config = let
    allEnabled = cfg.tools.all.enable;
  in
    lib.mkMerge [
      # === Tools ===
      (lib.mkIf (allEnabled || cfg.tools.cracking.enable) (import ./tools/cracking.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.networking.enable) (lib.mkMerge [
        (import ./tools/networking.nix {inherit pkgs;})
        {users.users.${cfg.user}.extraGroups = ["wireshark"];}
      ]))

      (lib.mkIf (allEnabled || cfg.tools.web-application.enable) (import ./tools/web-application.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.database-clients.enable) (import ./tools/database-clients.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.remote-enumeration.enable) (import ./tools/remote-enumeration.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.communication.enable) (import ./tools/communication.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.remote-access.enable) (import ./tools/remote-access.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.exploitation.enable) (import ./tools/exploitation.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.active-directory.enable) {
        environment.systemPackages = with pkgs; [
          kerbrute
          python312Packages.impacket
          responder
          ldapdomaindump
          krb5
          bloodhound-py
          custom-packages.pywhisker
        ];
      })

      (lib.mkIf (allEnabled || cfg.tools.programming.enable) (import ./tools/programming.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.office-tools.enable) {
        environment.systemPackages = [pkgs.libreoffice];
      })

      (lib.mkIf (allEnabled || cfg.tools.custom-packages.enable) {
        environment.systemPackages = with custom-packages; [
          go-windapsearch
          seclists
          mimikatz
          godpotato
          ligolo-ng-binaries
          custom-scripts
          sliver
          pspy
          vulnx
        ];
        system.activationScripts.arsenal = ''
          ln -sfn ${custom-packages.arsenal}/arsenal /arsenal
        '';
      })

      (lib.mkIf (allEnabled || cfg.tools.nix-shells.enable) (import ./tools/nix-shells.nix {inherit pkgs;}))

      (lib.mkIf (allEnabled || cfg.tools.other.enable) (import ./tools/other.nix {inherit pkgs;}))

      # === Services ===
      (lib.mkIf cfg.services.sliver.enable (import ./services/sliver.nix {inherit cfg pkgs custom-packages;}))

      (lib.mkIf cfg.services.bloodhound.enable (import ./services/bloodhound.nix {inherit cfg pkgs;}))
    ];
}
