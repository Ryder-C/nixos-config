{
  ry.ollama.nixos = {pkgs, ...}: {
    systemd.tmpfiles.rules = [
      "d /storage/models 0755 ollama ollama -"
    ];
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        user = "ollama";
        models = "/storage/models";
      };
      open-webui = {
        enable = true;
        port = 8081;
        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          WEBUI_AUTH = "False";
        };
      };
    };
  };
}
