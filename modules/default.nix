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

      (lib.mkIf (allEnabled || cfg.tools.other.enable) (import ./tools/other.nix {inherit pkgs;}))

      # === Services ===
      (lib.mkIf cfg.services.sliver.enable {
        systemd.services.sliver-server = {
          description = "Sliver C2 Server";
          wantedBy = ["multi-user.target"];
          after = ["network.target"];
          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = "users";
            ExecStartPre = "${custom-packages.sliver}/bin/sliver-server unpack --force";
            ExecStart = "${custom-packages.sliver}/bin/sliver-server daemon";
            ExecStartPost = [
              "${pkgs.coreutils}/bin/mkdir -p /home/${cfg.user}/.sliver-client/configs"
              "-${custom-packages.sliver}/bin/sliver-server operator --name ${cfg.user} --lhost localhost --save /home/${cfg.user}/.sliver-client/configs/${cfg.user}.cfg"
            ];
            Restart = "on-failure";
            RestartSec = "10";
            AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
            WorkingDirectory = "/home/${cfg.user}";
          };
        };
      })

      (lib.mkIf cfg.services.bloodhound.enable {
        virtualisation.docker = {
          enable = true;
          autoPrune.enable = true;
        };
        users.users.${cfg.user}.extraGroups = ["docker"];
        environment.etc."bloodhound/docker-compose.yml".text = ''
          services:
            app-db:
              image: docker.io/library/postgres:16
              environment:
                - PGUSER=bloodhound
                - POSTGRES_USER=bloodhound
                - POSTGRES_PASSWORD=bloodhoundcommunityedition
                - POSTGRES_DB=bloodhound
              volumes:
                - postgres-data:/var/lib/postgresql/data
              healthcheck:
                test: ["CMD-SHELL", "pg_isready -U bloodhound -d bloodhound -h 127.0.0.1 -p 5432"]
                interval: 10s
                timeout: 5s
                retries: 5
                start_period: 30s
            graph-db:
              image: docker.io/library/neo4j:4.4
              environment:
                - NEO4J_AUTH=neo4j/bloodhoundcommunityedition
                - NEO4J_dbms_allow__upgrade=true
              ports:
                - 0.0.0.0:7687:7687
                - 0.0.0.0:7474:7474
              volumes:
                - neo4j-data:/data
              healthcheck:
                test: ["CMD-SHELL", "wget -O /dev/null -q http://localhost:7474 || exit 1"]
                interval: 10s
                timeout: 5s
                retries: 5
                start_period: 30s
            bloodhound:
              image: docker.io/specterops/bloodhound:latest
              environment:
                - bhe_disable_cypher_complexity_limit=false
                - bhe_enable_cypher_mutations=false
                - bhe_graph_query_memory_limit=2
                - bhe_database_connection=user=bloodhound password=bloodhoundcommunityedition dbname=bloodhound host=app-db
                - bhe_neo4j_connection=neo4j://neo4j:bloodhoundcommunityedition@graph-db:7687/
              ports:
                - 0.0.0.0:8888:8080
              volumes:
                - /etc/bloodhound/bloodhound.config.json:/bloodhound.config.json:ro
              depends_on:
                app-db:
                  condition: service_healthy
                graph-db:
                  condition: service_healthy
          volumes:
            neo4j-data:
            postgres-data:
        '';
        environment.etc."bloodhound/bloodhound.config.json".text = builtins.toJSON {
          version = 1;
          bind_addr = "0.0.0.0:8080";
          metrics_port = ":2112";
          root_url = "http://0.0.0.0:8080/";
          work_dir = "/opt/bloodhound/work";
          log_level = "INFO";
          log_path = "bloodhound.log";
          tls = {cert_file = ""; key_file = "";};
          collectors_base_path = "/etc/bloodhound/collectors";
          default_admin = {
            principal_name = "admin";
            first_name = "Bloodhound";
            last_name = "Admin";
            email_address = "admin@roach.local";
          };
        };
        systemd.services.bloodhound-ce = {
          description = "BloodHound Community Edition";
          wantedBy = ["multi-user.target"];
          after = ["docker.service" "network-online.target"];
          requires = ["docker.service"];
          serviceConfig = {
            Type = "simple";
            WorkingDirectory = "/etc/bloodhound";
            ExecStart = "${pkgs.docker-compose}/bin/docker-compose up";
            ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
            Restart = "on-failure";
            RestartSec = "10";
          };
        };
        environment.systemPackages = [pkgs.docker-compose];
      })
    ];
}
