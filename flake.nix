{
  description = "flake for ishikawa";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    old_pkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
      inputs.nixpkgs.follows = "old_pkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , hyprland
    , nixos-06cb-009a-fingerprint-sensor
    , old_pkgs
    , lanzaboote
    }:
    {
      nixosConfigurations = {
        ishikawa = nixpkgs.lib.nixosSystem rec {
          specialArgs = inputs;
          modules = [
            ./laptop/configuration.nix
            ./smb/smb.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = nixpkgs.lib.mkMerge [
                specialArgs
              ];
              home-manager.users.kusanagi = import ./homemanager/kusanagi.nix;
            }
          ];
        };
        borma = nixpkgs.lib.nixosSystem rec {
          specialArgs = inputs;
          modules = [
            ./lenovo/configuration.nix
            ./smb/smb.nix
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            # nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
            # nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
            {
              home-manager.extraSpecialArgs = nixpkgs.lib.mkMerge [
                specialArgs
              ];
              home-manager.users.kusanagi = import ./homemanager/kusanagi.nix;
            }
          ];
        };
      };
    };
}
