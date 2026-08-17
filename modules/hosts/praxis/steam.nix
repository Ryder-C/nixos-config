_: {
  # Steam Rich Presence runs only here — praxis is the machine that plays.
  den.aspects.praxis.nixos = {config, ...}: {
    programs.steam.presence = {
      enable = true;
      steamApiKeyFile = config.age.secrets.steam_key.path;
      userIds = ["76561198311078521"];
    };

    age.secrets.steam_key = {
      file = ../../../secrets/steam_key.age;
      owner = "ryder";
      mode = "0400";
    };
  };
}
