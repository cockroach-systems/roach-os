{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nmap
    samba # provides smbclient
    openldap # provides ldap-utils
    cadaver # webdav client
    rpcbind
    nfs-utils # provides nfs-common
    inetutils # provides ftp
    netexec
    postman
    # nmp enum
    net-snmp
    onesixtyone
  ];

  # Nmap configuration - set NMAPDIR so nmap can find its scripts
  environment.variables.NMAPDIR = "${pkgs.nmap}/share/nmap";

  # WARNING: SUID nmap is a local privesc vector!
  # We accept this risk because:
  #   1. Allows nmap to run as root while preserving user's .envrc environment
  #   2. If our attack box is compromised, we're already fucked anyway
  # TODO: Revisit this - maybe capabilities + fixing scripts is cleaner long-term
  warnings = [
    ''
      ===================== WARNING =====================
      SUID nmap is enabled in remote-enumeration.nix
      This is a LOCAL PRIVESC VECTOR!
      (accepted risk for .envrc compatibility)
      ===================================================
    ''
  ];

  security.wrappers.nmap = {
    source = "${pkgs.nmap}/bin/nmap";
    owner = "root";
    group = "root";
    setuid = true;
  };
}
