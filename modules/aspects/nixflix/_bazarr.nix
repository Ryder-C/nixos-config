{config, ...}: let
  whisperPort = 9000;
in {
  services.bazarr = {
    enable = true;
    group = "media";
    dataDir = "/storage/.state/bazarr";
  };

  # CDI device passthrough so the Whisper container can reach the GPU. fornax's
  # nvidia aspect already pins the legacy_580 driver with open=false (Pascal has
  # no open-module support), which is what the toolkit generates the CDI spec
  # against. Referenced below via --device=nvidia.com/gpu=all.
  hardware.nvidia-container-toolkit.enable = true;

  # Whisper ASR webservice -- backs Bazarr's Whisper provider for AI-generated
  # subtitles when none are available from other providers. Configure it in the
  # Bazarr UI: Providers -> Whisper, endpoint "http://127.0.0.1:9000".
  #
  # GPU image (faster_whisper / CTranslate2 on the 1070 Ti). Note: Pascal lacks
  # tensor cores and has poor FP16, so CTranslate2 runs float32 here -- accurate
  # but heavier on VRAM and slower than newer cards.
  virtualisation.oci-containers.containers.whisper-asr = {
    image = "onerahmet/openai-whisper-asr-webservice:latest-gpu";
    ports = ["127.0.0.1:${toString whisperPort}:9000"];
    environment = {
      ASR_ENGINE = "faster_whisper";
      ASR_MODEL = "medium";
      ASR_DEVICE = "cuda";
      TZ = "America/Los_Angeles";
    };
    volumes = [
      "/var/lib/whisper-asr/cache:/root/.cache"
    ];
    extraOptions = ["--device=nvidia.com/gpu=all"];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/whisper-asr 0755 root root - -"
    "d /var/lib/whisper-asr/cache 0755 root root - -"
  ];

  ry.homepage.services."Arr" = [
    {
      "Bazarr" = {
        href = "http://${config.networking.hostName}:6767";
        icon = "bazarr";
        widget = {
          type = "bazarr";
          url = "http://localhost:6767";
          key = "7556d85e574df4f87e8117608a75ba94";
        };
      };
    }
  ];
}
