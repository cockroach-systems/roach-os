{cfg, pkgs, custom-packages}:
{
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
}
