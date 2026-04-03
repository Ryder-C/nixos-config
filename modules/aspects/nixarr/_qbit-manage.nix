{pkgs, ...}: let
  tagDeprecatedScript = pkgs.writeShellScript "tag-deprecated" ''
    is_upgrade="''${Sonarr_IsUpgrade:-$Radarr_IsUpgrade}"
    if [ "$is_upgrade" != "True" ]; then
      exit 0
    fi
    hash="''${Sonarr_Download_Id:-$Radarr_Download_Id}"
    if [ -n "$hash" ]; then
      ${pkgs.curl}/bin/curl -s "http://localhost:8080/api/v2/torrents/addTags" \
        -d "hashes=$hash" \
        -d "tags=deprecated"
    fi
  '';

  configFile = pkgs.writeText "qbit-manage-config.yml" (builtins.toJSON {
    qbt = {
      host = "http://localhost:8080";
      user = null;
      pass = null;
    };

    directory = {
      root_dir = "/storage/Torrents/";
      remote_dir = "/storage/Torrents/";
      cross_seed = "/storage/Torrents/cross-seed";
      orphaned_dir = "/storage/Torrents/orphaned_data";
    };

    cat = {
      cross-seed = "/storage/Torrents/cross-seed";
      radarr = "/storage/Torrents/radarr";
      radarr-anime = "/storage/Torrents/radarr-anime";
      tv-sonarr = "/storage/Torrents/tv-sonarr";
      tv-sonarr-anime = "/storage/Torrents/tv-sonarr-anime";
    };

    tracker = {
      seedpool = {
        tag = "SP";
      };
      other = {
        tag = "PUB";
      };
    };

    share_limits = {
      deprecated = {
        priority = 18;
        include_all_tags = ["deprecated"];
        exclude_all_tags = ["manage-ignore"];
        max_ratio = 2.0;
        max_seeding_time = "14d";
        cleanup = true;
      };
      cross-seed = {
        priority = 19;
        include_all_tags = ["cross-seed"];
        exclude_all_tags = ["manage-ignore"];
        max_ratio = -1;
        cleanup = false;
      };
      public = {
        priority = 20;
        include_all_tags = ["PUB"];
        exclude_all_tags = ["manage-ignore"];
        max_ratio = 1.3;
        max_seeding_time = "7d";
        limit_upload_speed = 100;
        cleanup = true;
      };
      perma = {
        priority = 99;
        exclude_all_tags = ["manage-ignore"];
        max_ratio = -1;
        cleanup = false;
      };
    };

    settings = {
      force_auto_tmm = true;
      tracker_error_tag = "issue";
      cross_seed_tag = "cross-seed";
      cat_filter_completed = true;
      share_limits_filter_completed = true;
      cat_update_all = true;
      force_auto_tmm_ignore_tags = ["manage-ignore"];
      disable_qbt_default_share_limits = true;
      tag_stalled_torrents = true;
      stalled_tag = "stalledDL";
    };

    recyclebin = {
      enabled = false;
    };

    orphaned = {
      empty_after_x_days = 0;
      exclude_patterns = [];
      max_orphaned_files_to_delete = -1;
    };
  });
in {
  environment.etc."qbit-manage/tag-deprecated".source = tagDeprecatedScript;

  systemd.services.qbit-manage = {
    description = "qbit-manage torrent lifecycle manager";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.writeShellScript "qbit-manage-setup" ''
        cp -f ${configFile} /var/lib/qbit-manage/config.yml
        chmod 644 /var/lib/qbit-manage/config.yml
      ''}";
      ExecStart = "${pkgs.qbit-manage}/bin/qbit-manage -cd /var/lib/qbit-manage --run --web-server=False -cu -tu -ro -sl -tte";
      StateDirectory = "qbit-manage";
      WorkingDirectory = "/var/lib/qbit-manage";
      ReadWritePaths = ["/storage/Torrents"];
    };
  };

  systemd.timers.qbit-manage = {
    description = "Run qbit-manage every 15 minutes";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "15min";
      Persistent = true;
    };
  };
}
