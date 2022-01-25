{ lib, ... }:
{
  # https://github.com/NixOS/nixpkgs/issues/58959#issuecomment-890841662
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
