{inputs, ...}: let
  allowOutsideAccess = false;
in {
  imports = [inputs.nixarr.nixosModules.default];

  services = {
    flaresolverr = {
      enable = true;
      openFirewall = false;
    };
    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };

  nixarr = {
    enable = true;
    mediaDir = "/storage4tb/media";
    stateDir = "/storage4tb/.state";

    jellyfin.enable = true;

    prowlarr = {
      enable = true;
      openFirewall = allowOutsideAccess;
    };
    sonarr = {
      enable = true;
      openFirewall = allowOutsideAccess;

      instances = {
        "anime".enable = true;
      };
    };
    radarr = {
      enable = true;
      openFirewall = allowOutsideAccess;

      instances = {
        "anime".enable = true;
      };
    };
    recyclarr = {
      enable = false;
      configuration = {
        sonarr = {
          series = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";

            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;

            # Create BOTH: WEB-2160p (general TV) and Anime (anime TV)
            include = [
              # General TV (highest quality WEB 2160p)
              {template = "sonarr-quality-definition-series";}
              {template = "sonarr-v4-quality-profile-web-2160p";}
              {template = "sonarr-v4-custom-formats-web-2160p";}

              # Anime TV (anime-specific sizes & CFs)
              {template = "sonarr-quality-definition-anime";}
              {template = "sonarr-v4-quality-profile-anime";}
              {template = "sonarr-v4-custom-formats-anime";}
            ];
          };
        };

        radarr = {
          movies = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";

            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;

            # UHD Bluray + WEB for movies, plus Anime support (optional but handy)
            include = [
              {template = "radarr-quality-definition-movie";}
              {template = "radarr-quality-profile-uhd-bluray-web";}
              {template = "radarr-custom-formats-uhd-bluray-web";}

              {template = "radarr-quality-profile-anime";}
              {template = "radarr-custom-formats-anime";}
            ];
          };
        };
      };
    };
  };
}
