let
  ryder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBKe9Q3rWE2xfBPp3oc4F+Edk9RqgTIio9OB6assgPw";
  users = [ryder];
in {
  "pia.age".publicKeys = users;
}
