{inputs, pkgs, ...} : 
{
	imports = [
		./apps
	];
    nixpkgs = {
        overlays = [ ];
        config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
        };
    };
	xdg.enable = true;
	home.username = "kusanagi";
	home.homeDirectory = "/home/kusanagi";
	programs.home-manager.enable = true;
	programs = {
		direnv = {
			enable = true;
			enableBashIntegration = true;
			nix-direnv.enable = true;
			};
		bash = {
			enable = true;
			bashrcExtra = ''
				eval "$(direnv hook bash)"
			'';
			};
		};
	home.packages = with pkgs; [
		unzip
		thunderbird
		alacritty
		wofi
		swww
		bitwarden
		dunst
		brightnessctl
		pamixer
		networkmanagerapplet
		waybar
		git
		swaylock-effects
		btop
		whatsapp-for-linux
		discord
		moonlight-qt
		psst
		playerctl
		teams-for-linux
		hunspell
		onedrive
		libreoffice
        pcmanfm
        lxmenu-data
        shared-mime-info
	];
	home.stateVersion = "23.11";
}
