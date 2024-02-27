{
	description = "flake for ishikawa";
	inputs = {
	  nixpkgs = {
	    url = "github:NixOS/nixpkgs/nixos-unstable";
	  };
	  home-manager.url = "github:nix-community/home-manager";
	  home-manager.inputs.nixpkgs.follows = "nixpkgs";
	  hyprland.url = "github:hyprwm/Hyprland";
	};

	outputs = inputs@{ self, nixpkgs, home-manager, hyprland}: {
	  nixosConfigurations = {
	    ishikawa = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
		  ./configuration.nix
		  ./nvidia.nix #curently not in use
		  ./greetd.nix
		  ./theme.nix
		  ./wireguard.nix
		  ./smb/smb.nix
		  home-manager.nixosModules.home-manager
		  {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
			home-manager.users.kusanagi = import ./kusanagi.nix;
		  }
		];
	    };
	  };
	};
}
