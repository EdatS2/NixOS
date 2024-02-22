{ pkgs, ...} : 
let
	menu = "wofi --show run";
	terminal  = "alacritty";
	lock_script = pkgs.pkgs.writeShellScriptBin "lock_screen" ''
		${pkgs.brightnessctl}/bin/brightnessctl s 20% &
		${pkgs.swaylock-effects}/bin/swaylock \
			--screenshots \
			--clock \
			--indicator \
			--indicator-radius 100 \
			--indicator-thickness 7 \
			--effect-blur 7x5 \
			--effect-vignette 0.5:0.5 \
			--ring-color bb00cc \
			--key-hl-color 880033 \
			--line-color 00000000 \
			--inside-color 00000088 \
			--separator-color 00000000 \
			--grace 2 \
			--fade-in 0.2
	'';
	startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
	${pkgs.swww}/bin/swww init &
	${pkgs.dunst}/bin/dunst &
	${pkgs.waybar}/bin/waybar &
	
	sleep 1
 	${pkgs.swww}/bin/swww img ${./gits.jpg} &
	'';
in
{
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
		neovim
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
	];
	wayland.windowManager.hyprland = {
	  enable = true;
	  package = pkgs.hyprland;
	  systemd.enable = true;
	  xwayland.enable = true;
	  settings = {
		exec-once = ''${startupScript}/bin/start'';
		"$mod" = "ALT";
		monitor = "eDP-1,1920x1080@60,0x0,1";
		windowrulev2 = [
			"opacity 0.9 override 0.7 override,class:(firefox),title:^(firefox)"
		];
		general = {
			gaps_in = 1;
			gaps_out = 4;
			resize_on_border = true;
		};
		decoration = {
			rounding=3;
			drop_shadow=0;
			shadow_range=60;
			active_opacity = 0.9;
			inactive_opacity = 0.7;
			"col.shadow"="0x66000000";
			};
		dwindle = {
			pseudotile=0;
			};
		gestures = {
			workspace_swipe = true;
		};
		bindm = [
			#mouse movements
			"$mod, mouse:272, movewindow"
			"$mod, mouse:273, resizewindow"
			"$ALTSHIFT, mouse:272, resizewindow"
		];
		bind  = [
			"ALTSHIFT, Q, killactive"
			"$mod, Return, exec, ${terminal}"
			"$mod, D, exec, ${menu}" 
			"$mod, V, togglefloating"
			"$mod, F, fullscreen, 0"
			"$mod, h, movefocus, l"
			"$mod, j, movefocus, d"
			"$mod, k, movefocus, u"
			"$mod, l, movefocus, l"
			"ALTSHIFT, h, movewindow, l"
			"ALTSHIFT, j, movewindow, d"
			"ALTSHIFT, k, movewindow, u"
			"ALTSHIFT, l, movewindow, r"
			"$mod, 1, workspace, 1"
			"$mod, 2, workspace, 2"
			"$mod, 3, workspace, 3"
			"$mod, 4, workspace, 4"
			"$mod, 5, workspace, 5"
			"$mod, 6, workspace, 6"
			"$mod, 7, workspace, 7"
			"$mod, 8, workspace, 8"
			"$mod, 9, workspace, 9"
			"$mod, 0, workspace, 10"
			"ALTSHIFT, 1, movetoworkspacesilent,1"
			"ALTSHIFT, 2, movetoworkspacesilent,2"
			"ALTSHIFT, 3, movetoworkspacesilent,3"
			"ALTSHIFT, 4, movetoworkspacesilent,4"
			"ALTSHIFT, 5, movetoworkspacesilent,5"
			"ALTSHIFT, 6, movetoworkspacesilent,6"
			"ALTSHIFT, 7, movetoworkspacesilent,7"
			"ALTSHIFT, 8, movetoworkspacesilent,8"
			"ALTSHIFT, 9, movetoworkspacesilent,9"
			"ALTSHIFT, 0, movetoworkspacesilent,10"
			"ALTSHIFT, c, exec, ${lock_script}/bin/lock_screen"
			"ALTSHIFT, s,exec, ${lock_script}/bin/lock_screen & systemctl suspend"
			"ALTSHIFT, p,exec, shutdown now"
		];
		binde = [
			",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
			",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
			",XF86AudioRaiseVolume,exec,pamixer -i 5"
			",XF86AudioLowerVolume,exec,pamixer -d 5"
		];
		misc = {
			disable_hyprland_logo = true;
			};
		"env" = "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0";
	  };
	};
	home.stateVersion = "23.11";
}
