{
  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixos, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: rec {
      pkgs = import nixos { inherit system; };
      packages."iso" = (nixos.lib.nixosSystem {
        inherit system;

        modules = [ "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" ]
          ++ [ "${nixos}/nixos/modules/installer/cd-dvd/channel.nix" ]
          ++ [{ boot.kernelPackages = pkgs.linuxPackages_latest; }] ++
          [{ hardware.firmware = with pkgs; [ firmwareLinuxNonfree ]; }]
          ++ [{ imports = [ ./issuecomment-890841662.nix ]; }];
      }).config.system.build.isoImage;
    });
}
