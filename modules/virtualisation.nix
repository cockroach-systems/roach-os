{
  cfg,
  pkgs,
  lib,
}: {
  # Rootless podman for ad-hoc containers (quick DB spin-ups during engagements,
  # e.g. `podman run --rm -p 3306:3306 -e MARIADB_ROOT_PASSWORD=root docker.io/library/mariadb`).
  # No daemon, no group membership required — just works for the primary user.
  virtualisation.podman = {
    enable = true;

    # Provide a `docker` CLI alias -> podman, but yield to the real docker
    # daemon when the bloodhound service (which needs docker) is enabled,
    # since the two can't both own the `docker` command / socket.
    dockerCompat = !cfg.services.bloodhound.enable;

    # DNS between containers on the default network (handy for compose stacks).
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
