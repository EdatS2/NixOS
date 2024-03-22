{ config, pkgs, inputs, ... }:
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
  home.packages = [
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      exec-once = ${startupScript}/bin/start
      $lock = ${lock_script}/bin/lock_screen
      env = WLR_NO_HARDWARE_CURSORS,1
      source = ./keybind.conf
      '';
#"env" = "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0";
    };
  home.file.".config/hypr/keybind.conf".source = ./dotfiles/keybind.conf;
}
