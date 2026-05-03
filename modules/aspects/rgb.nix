{
  ry.rgb.nixos = {
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";
      startupProfile = "main.orp";
    };
  };
}
