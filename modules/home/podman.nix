{
  pkgs,
  username,
  ...
}: {
  home.packages = [pkgs.podman];

  services.podman = {
    enable = true;

    containers = {
      plex-rpc = {
        image = "ghcr.io/phin05/discord-rich-presence-plex:latest";
        autoStart = true;
        environment = {
          DRPP_UID = "1000";
          DRPP_GID = "100";
        };
        volumes = [
          "/run/user/1000:/run/app"
          "/home/${username}/podman/plex-rpc/data:/app/data"
        ];
      };
    };
  };
}
