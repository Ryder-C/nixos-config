{config, ...}: {
  # OnePacerr (https://github.com/eltharynd/OnePacerr) -- automates One Pace, the
  # fan re-edit of One Piece. It polls One Pace's RSS/metadata feed, grabs new or
  # missing arcs through qBittorrent, and organizes them into the Jellyfin
  # "One Pace" library.
  #
  # Adopting the existing library WITHOUT re-downloading:
  #   - The hand-built library lives at /storage/media/library/one-pace/One Pace/
  #     and already uses OnePacerr's default layout + filename format
  #     ("One Pace - SxxEyy - Title.mkv").
  #   - The Jellyfin "One Pace" library's virtual folder points at
  #     /storage/media/library/one-pace. In jellyfin mode OnePacerr asks Jellyfin
  #     for that path, then appends LIBRARY_SERIES_FOLDER_NAME ("One Pace"),
  #     resolving to exactly /storage/media/library/one-pace/One Pace.
  #   - Because we bind-mount that path 1:1 into the container, the path Jellyfin
  #     reports is valid inside the container too, so no MOUNT_* translation is
  #     needed. OnePacerr sees the present episodes, marks them satisfied, and
  #     only downloads genuinely missing/new releases.
  virtualisation.oci-containers.containers.onepacerr = {
    image = "ghcr.io/eltharynd/onepacerr:latest";
    # Host networking so it can reach Jellyfin (localhost:8096) and qBittorrent
    # (localhost:8080). Its status API is served on :3007 (see PORT below).
    extraOptions = ["--network=host"];
    volumes = [
      # Same paths the host/Jellyfin/qBittorrent use, so no path remapping.
      "/storage/media/library/one-pace:/storage/media/library/one-pace"
      "/storage/Torrents:/storage/Torrents"
    ];
    # JELLYFIN_PASSWORD=<jellyfin-admin secret>, written by the preStart below.
    environmentFiles = ["/run/onepacerr/env"];
    environment = {
      TZ = "America/Los_Angeles";
      LOG_LEVEL = "info";
      # ryder:media -- owner/group of the existing library (files are mode 0664,
      # media-group writable). Renames, metadata writes, and new downloads land
      # as ryder:media. (ryder=uid 1000, media=gid 169 on fornax.)
      PUID = "1000";
      PGID = "169";

      # OnePacerr's status/health HTTP server. Default 3000 is already taken on
      # this host (and --network=host binds it directly), so move it off 3000.
      PORT = "3007";

      # -- Library / Jellyfin --
      LIBRARY_MEDIA_SERVER = "jellyfin";
      LIBRARY_SERIES_NAME = "One Pace";
      LIBRARY_SERIES_FOLDER_NAME = "One Pace";
      LIBRARY_FILENAME_FORMAT = "{SERIES_NAME} - S{ARC}E{EPISODE} - {TITLE}.mkv";
      JELLYFIN_URL = "http://localhost:8096";
      # OnePacerr's Jellyfin client only does username+password auth (no API key).
      # "ryder" is the admin account; JELLYFIN_PASSWORD is injected from the
      # jellyfin-admin agenix secret via environmentFiles below (the secret holds
      # the raw password, so a preStart wraps it into KEY=VALUE form).
      JELLYFIN_USERNAME = "ryder";
      JELLYFIN_LIBRARY_NAME = "One Pace";
      # Poster art set written for the series/seasons (falls back to "default"
      # for any poster missing from the set).
      METADATA_POSTER_SET = "piratezekk";

      # -- Torrent client (qBittorrent) --
      # WebUI\LocalHostAuth is disabled (see ../torrents.nix), so requests from
      # localhost skip auth; these credentials are placeholders to satisfy OnePacerr.
      TORRENT_CLIENT = "qbittorrent";
      TORRENT_URL = "http://localhost:8080";
      TORRENT_USER = "admin";
      TORRENT_PASSWORD = "adminadmin";
      TORRENT_CATEGORY = "onepacerr";

      # -- Pipeline --
      # Steady state: the existing library has been adopted, verified, organized,
      # and had its metadata/posters written. Leave present files alone now (these
      # passes also re-hash the whole library and re-write .nfo/posters every cycle,
      # and the organize pass is what created the padded "Season 0N" folders). New
      # One Pace releases are still downloaded and imported. To re-run a full
      # adoption pass (e.g. after manual library edits), flip these back to "false".
      PIPELINE_SKIP_VERIFY_PRESENT_FILES = "true";
      PIPELINE_SKIP_ORGANIZE_PRESENT_FILES = "true";
      PIPELINE_SKIP_UPDATE_METADATA_PRESENT_FILES = "true";
      PIPELINE_SKIP_POSTERS = "true";
      # Keep grabbing + importing genuinely new/missing releases.
      PIPELINE_SKIP_DOWNLOADS = "false";
      PIPELINE_SKIP_DOWNLOADS_IMPORTS = "false";
      # Never re-fetch a file that's already present.
      PIPELINE_FORCE_REDOWNLOAD = "false";
      # Prefer extended cuts (episodes with extra scenes). For episodes that have
      # an extended variant, OnePacerr will swap your standard cut for the extended
      # one -- an intentional per-episode upgrade, not a full re-download.
      PIPELINE_PREFER_EXTENDED = "true";
      # Alternate edits (e.g. the optional G-8 / Navarone filler arc cut at the end
      # of Skypiea). Off -> keep the standard edit. Set "true" to pull such variants.
      PIPELINE_PREFER_ALTERNATE = "false";
    };
  };

  # OnePacerr needs /storage mounted and the services it drives up first.
  # qBittorrent is started by the pia-vpn port-forward script, so depend on that.
  systemd.services."${config.virtualisation.oci-containers.backend}-onepacerr" = {
    unitConfig.RequiresMountsFor = "/storage";
    after = ["jellyfin.service" "pia-vpn.service"];
    wants = ["jellyfin.service"];
    serviceConfig.RuntimeDirectory = "onepacerr";
    # Render the env-file from the raw-password agenix secret before the container
    # starts (/run/onepacerr is the RuntimeDirectory, root-only).
    preStart = ''
      umask 0077
      printf 'JELLYFIN_PASSWORD=%s\n' "$(cat ${config.age.secrets.jellyfin-admin.path})" > /run/onepacerr/env
    '';
  };
}
