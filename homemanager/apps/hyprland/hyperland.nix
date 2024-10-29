{ config, pkgs, inputs, hyprland, ... }:
let
  menu = "wofi --show run";
  terminal = "alacritty";
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
  bluetoothToggle = pkgs.pkgs.writeShellScriptBin "toggleBlue" ''
    # Get the current Bluetooth status
    sleep 5
    bluetooth_status=$(rfkill | awk '$1 == 1 && $2 == "bluetooth" {print $4}')
    
    if [ "$bluetooth_status" == "blocked" ]; then
        # If Bluetooth is active, turn it off
        bluetoothctl power off
        echo "Bluetooth turned OFF."
    else
        # If Bluetooth is inactive, turn it on
        bluetoothctl power on
        echo "Bluetooth turned ON."
    fi
  '';
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    	${pkgs.swww}/bin/swww init &
    	${pkgs.dunst}/bin/dunst &
    	${pkgs.waybar}/bin/waybar &
        ${pkgs.thunderbird}/bin/thunderbird &
        ${pkgs.zapzap}/bin/zapzap &
        ${pkgs.vorta}/bin/vorta -d &
    	
    	sleep 1
     	${pkgs.swww}/bin/swww img ${./gits.jpg} &
    	'';
in
{
  home.packages = with pkgs; [
    hyprland-workspaces
    xdg-desktop-portal-hyprland
  ];
  #  nix.settings = {
  #    substituters = ["https://hyprland.cachix.org"];
  #    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  #  };
  wayland.windowManager.hyprland = {
    #    package= inputs.hyprland.packages.${pkgs.system}.hyprland;
    package = pkgs.hyprland;
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      exec-once = ${startupScript}/bin/start
      $lock = ${pkgs.hyprlock}/bin/hyprlock -c ~/.config/hyprlock/hyprlock.conf
      $bluetoothToggle = ${bluetoothToggle}/bin/toggleBlue
      env = WLR_NO_HARDWARE_CURSORS,1
      source = ./keybind.conf
    '';
    #"env" = "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0";
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
  };
  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  home.file.".config/hypr/keybind.conf".source = ./dotfiles/keybind.conf;
}
