{
	description = "flake for ishikawa";
	inputs = {
	  nixpkgs = {
	    url = "github:NixOS/nixpkgs/nixos-unstable";
	  };
	  home-manager.url = "github:nix-community/home-manager";
	  home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs@{ self, nixpkgs, home-manager}: 
    let
        inherit (self) outputs;
    in
    {
	  nixosConfigurations = {
	    ishikawa = nixpkgs.lib.nixosSystem rec {
            specialArgs = {
            inherit inputs outputs;
            hasUI= true;
            };
		modules = [
		  ./laptop/configuration.nix
		  ./smb/smb.nix
		  home-manager.nixosModules.home-manager
		  {
            home-manager.extraSpecialArgs = nixpkgs.lib.mkMerge [
                {
                    inherit inputs outputs;
                }
                specialArgs
                ];
			home-manager.users.kusanagi = import ./homemanager/kusanagi.nix;
		  }
		];
	    };
	  };
	};
}
