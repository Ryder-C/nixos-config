{inputs}: {
  services.shoko = {
    enable = true;
  };

  systemd.services.shoko = {
    unitConfig.RequiresMountsFor = "/storage";
    serviceConfig = {
      SupplementaryGroups = ["media"];
      ReadWritePaths = ["/storage/media"];
    };
  };

  nixflix.jellyfin = {
    system.pluginRepositories.Shokofin = {
      url = "https://raw.githubusercontent.com/ShokoAnime/Shokofin/metadata/stable/manifest.json";
      hash = "sha256-SVAS4NNHhLHUL9QV/wsmDc1L9j+CiA6tM+nK5FabTcY=";
    };

    plugins."Shoko" = {
      enable = true;
      package = inputs.nixflix.lib.jellyfinPlugins.fromRepo {
        version = "6.0.5.11";
        hash = "sha256-U0kxBdN2526qpR9ImVjHUVQKYezMkHrjUxVWWb6mvKs=";
        repository = "Shokofin";
      };
    };
  };
}
