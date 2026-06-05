{pkgs, ...}: let
  configFile = pkgs.writeText "qbit-manage-config.yml" (builtins.toJSON {
    commands = {
      tag_nohardlinks = true;
      tag_update = true;
      cat_update = true;
      tag_tracker_error = true;
      rem_orphaned = true;
      share_limits = true;
    };

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
      cross-seed-noHL = {
        priority = 1;
        include_all_tags = ["cross-seed" "noHL"];
        exclude_all_tags = ["manage-ignore"];
        max_seeding_time = 0;
        cleanup = true;
      };
      cross-seed = {
        priority = 2;
        include_all_tags = ["cross-seed"];
        exclude_all_tags = ["manage-ignore" "noHL"];
        max_ratio = -1;
        cleanup = false;
      };
      public-noHL = {
        priority = 3;
        include_all_tags = ["PUB" "noHL"];
        exclude_all_tags = ["manage-ignore"];
        max_seeding_time = 0;
        cleanup = true;
      };
      SP-noHL = {
        priority = 4;
        include_all_tags = ["SP" "noHL"];
        exclude_all_tags = ["manage-ignore"];
        max_seeding_time = "11d";
        cleanup = true;
      };
      public = {
        priority = 5;
        include_all_tags = ["PUB"];
        exclude_all_tags = ["manage-ignore" "noHL"];
        max_ratio = 2.0;
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
      tag_nohardlinks_filter_completed = true;
      cat_update_all = true;
      nohardlinks_tag = "noHL";
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

    nohardlinks = {
      radarr = {};
      tv-sonarr = {};
      tv-sonarr-anime = {};
      cross-seed = {};
    };
  });
in {
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
      ExecStart = "${pkgs.qbit-manage}/bin/qbit-manage -cd /var/lib/qbit-manage --run --web-server=False -cu -tu -ro -sl -tte -tnhl";
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
