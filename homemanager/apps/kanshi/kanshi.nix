{ pkgs, ... }:

{
  home.packages = [
  ];

  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile.name = "iiyama";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "iiyama North America PL3466WQ";
            scale = 2.0;
            mode = "3440x1440@60Hz";
          }
        ];
      }
      {
          profile.name = "undocked";
          profile.outputs = [{ criteria = "eDP-1";}];
      }
    ];
  };

}
