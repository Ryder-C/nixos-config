let
  praxis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBKe9Q3rWE2xfBPp3oc4F+Edk9RqgTIio9OB6assgPw";
  fornax = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQMQHflbq0edpmCdU0xFfySV8RZj7JMhCsw837sy2h8";
  users = [praxis fornax];
in {
  "pia.age".publicKeys = users;
  "steam_key.age".publicKeys = users;
  "cross-seed.age".publicKeys = users;
  "openclaw_telegram.age".publicKeys = users;
  "cloudflare-api-token.age".publicKeys = users;
}
