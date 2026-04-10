{inputs, ...}: {
  flake-file.inputs.nix-openclaw = {
    url = "github:openclaw/nix-openclaw";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry = {
    openclaw.nixos = {
      nixpkgs.overlays = [inputs.nix-openclaw.overlays.default];
      age.secrets.openclaw_telegram = {
        file = ../../secrets/openclaw_telegram.age;
        owner = "ryder";
        mode = "0400";
      };
    };

    openclaw.homeManager = {
      osConfig,
      pkgs,
      ...
    }: {
      imports = [inputs.nix-openclaw.homeManagerModules.openclaw];

      home.packages = [pkgs.brave];

      programs.openclaw = {
        enable = true;
        excludeTools = ["nodejs_22"];
        documents = ./openclaw-docs;

        instances.default = {
          enable = true;
          config = {
            plugins.entries.acpx.enabled = false;

            env.vars = {
              OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
              OLLAMA_API_KEY = "ollama-local";
              OPENCLAW_NIX_MODE = "1";
              # This helps inside the gateway but we also need it for the process itself
              NODE_OPTIONS = "--dns-result-order=ipv4first";
            };

            models = {
              providers = {
                ollama = {
                  api = "ollama";
                  apiKey = "ollama-local";
                  auth = "api-key";
                  baseUrl = "http://127.0.0.1:11434";
                };
              };
            };

            mcp.servers = {
              nix = {
                command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
              };
            };
            commands.mcp = true;

            gateway = {
              mode = "local";
              auth = {
                # A token is required for local authentication
                token = "local-openclaw-token-ryder";
              };
            };

            channels.telegram = {
              tokenFile = osConfig.age.secrets.openclaw_telegram.path;
              allowFrom = [6599976454];
              groups."*" = {requireMention = true;};
              heartbeat.directPolicy = "allow";
            };

            agents.defaults = {
              model = "ollama/gemma4:26b";
              timeoutSeconds = 600;

              sandbox = {
                backend = "docker";
                browser = {
                  enabled = true;
                  headless = true;
                  autoStart = true;
                  allowHostControl = true;
                };
              };
            };

            browser = {
              enabled = true;
              executablePath = "${pkgs.brave}/bin/brave";
              profile = "user";
            };
          };
        };
      };

      home.sessionVariables = {
        NODE_OPTIONS = "--dns-result-order=ipv4first";
      };

      systemd.user.services."openclaw-gateway" = {
        Install.WantedBy = ["default.target"];
        Service.Environment = [
          "OLLAMA_API_BASE_URL=http://127.0.0.1:11434"
          "NODE_OPTIONS=--dns-result-order=ipv4first"
        ];
      };
    };
  };
}
