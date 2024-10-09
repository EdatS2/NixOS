{ config, pkgs, inputs, ... }:

{
  home.packages = [
  ];
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 14.0;
      font.normal = 
        { 
            family = "JetBrainsMono Nerd Font"; 
            # style = "Mono"; 
            };
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
      ];
    };
  };
}
