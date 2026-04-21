{cfg, pkgs}:
{
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
}
