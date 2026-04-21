{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    netcat-gnu # netcat
    socat
    tcpdump
    wireshark
    wireguard-tools
    openvpn
    lftp # Advanced FTP/SFTP client with scripting
    sshpass # SSH password automation
    updog
  ];

  # Wireshark configuration
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # Add user to wireshark group for packet capture
  users.users.eknovitz.extraGroups = ["wireshark"];
}

