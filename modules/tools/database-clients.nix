{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Amjith's fancy CLI suite
    mycli # MySQL
    pgcli # PostgreSQL
    litecli # SQLite
    #mssql-cli # MS SQL Server
    mariadb
    postgresql # provides postgresql-client
    freetds # provides freetds-bin for mssql
    sqlite
    dbeaver-bin
    redis # provides redis-cli
    mongosh # MongoDB shell client
  ];
}

