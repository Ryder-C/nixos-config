_: {
  ry.home-services.homeManager = {
    services = {
      cliphist = {
        enable = true;
        allowImages = true;
      };
      playerctld.enable = true;
      jellyfin-mpv-shim = {
        enable = true;
        settings = {
          fullscreen = true;
          transcode_hdr = false;
        };
        mpvConfig = {
          vo = "gpu-next";
          target-colorspace-hint = true;
          gpu-api = "vulkan";
          gpu-context = "waylandvk";

          target-trc = "pq";
          target-prim = "bt.2020";
          target-peak = "1000";
          hdr-compute-peak = "no";
        };
      };
    };
  };
}
