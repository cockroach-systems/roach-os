{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    freerdp # provides xfreerdp for RDP connections
    rdesktop # classic RDP client
    tigervnc # provides vncviewer for VNC connections
    pwncat
    evil-winrm
  ];
}
