{username, ...}: {
  services.podman = {
    enable = false;

    containers = {
      "plex-rpc" = {
        image = "ghcr.io/phin05/discord-rich-presence-plex:latest";
        autoStart = true;
        environment = {
          DRPP_UID = "1000";
          DRPP_GID = "100";
          DRPP_PLEX_SERVER_NAME_INPUT = "server";
        };
        volumes = [
          "/run/user/1000:/run/app"
          "/home/${username}/podman/plex-rpc/data:/app/data"
        ];
      };
    };
  };
}
