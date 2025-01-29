#sdqEdit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./greetd.nix
      #      ./theme.nix
      ./wireguard.nix
    ];
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # use the latest hardened kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPatches = [ {
  #     name = "full preempt_rt";
  #     patch = null;
  #     extraStructuredConfig = with lib.kernel; {
  #       PREEMPT_RT = yes;
  #       # EXPERT = yes;
  #       PREEMPT_VOLUNTARY = lib.mkForce no;
  #       RT_GROUP_SHED = lib.mkForce (option no);
  #     };
  # } ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.enable = true;
  #setting up lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  services.udev.packages = with pkgs; [
    vial
    via
  ];
  # virtualization
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.docker.storageDriver = "btrfs";
  # biometrics 
  # services.open-fprintd = {
  #     enable = true;
  #     # tod.enable = true;
  #     # tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  # };
  # # services.python-validity.enable = true;
  # nix.distributedBuilds = true;
  # nix.buildMachines = [
  # "Melchior" {
  #   system = "x86_64-linux";
  #   sshKey = "/home/kusanagi/.ssh/id_ed25519";
  #   sshUser = "admin";
  #   hostName = "192.168.88.15";
  #   maxJobs = 20;
  #   speedFactor = 10;
  # }
  # ];
  services.fprintd = {
    enable = false;
    tod = {
      enable = true;
      driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
        calib-data-file = ./calib-data.bin;
      };
    };
  };
  nix.buildMachines = [{
      hostName = "melchior_build";
      system = "x86_64-linux";
      protocol = "ssh";
      maxJobs = 18;
      speedFactor = 10;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
  }];
  # nix.distributedBuilds = true;
  # nix.extraOptions = " builders-use-substitutes = true\n";
  #powermanagement
  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  # services.btrbk = {
  #   instances."Sibelius" = {
  #     onCalendar = "daily";
  #     settings = {
  #       ssh_identity = "/home/kusanagi/.ssh/btrbk";
  #       ssh_user = "btrbk";
  #       stream_compress = "lz4";
  #       volume."/" = {
  #         target = "ssh://192.168.2.220/backup/backup";
  #         subvolume = "home";
  #       };
  #     };
  #   };
  # };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };

  #file explorer
  programs.zsh.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.davmail = {
    enable = true;
    url = "https://outlook.office365.com/EWS/Exchange.asmx";
    config = {
      davmail.mode = "O365Modern";
      davmail.allowRemote = false;
      davmail.imapPort = 1143;
      davmail.ldapPort = 1390;
      davmail.caldavPort = 1080;
      davmail.smtpPort = 1025;
      davmail.smtpSaveInSent = true;
      davmail.folderSizeLimit = 10;
      davmail.caldavAutoSchedule = true;
      log4j.logger.rootLogger = "DEBUG";
    };
  };
  services.tailscale.enable = true;
  services.tumbler.enable = true;
  nixpkgs.overlays = [
    (final: prev:
      {
        strongswanNM' = prev.strongswanNM.override {
          enableNetworkManager = false;
        };
      })
    (final: prev:
      {
        strongswan' = prev.strongswanNM'.overrideAttrs (old: {
          configureFlags = (old.configureFlags or [ ]) ++ [
            "--enable-eap-peap"
            "--enable-nm"
            "--with-nm-ca-dir=${pkgs.cacert.unbundled}/etc/ssl/certs"
          ];
          buildInputs = (old.buildInputs or [ ]) ++ [
            pkgs.cacert.unbundled
          ];
        });
      })
  ];

  networking.hostName = "borma"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true; # Easiest to use and most distros use this by default.
    plugins = [
      pkgs.networkmanager_strongswan
    ];
  };
  programs.steam = {
    enable = true;
  };
  services.strongswan-swanctl = {
    enable = false;
    swanctl = {
      connections.TUE = {
        version = 2;
        remote_addrs = [ "vpn-student.tue.nl" ];
        encap = true;
        vips = [ "0.0.0.0" "::" ];
        local_port = 500;
        remote."remote-1" = {
          auth = "pubkey";
          #cacerts = ["/etc/ssl/certs/ca-bundle.crt"];
        };
        local."local-1" = {
          auth = "eap-mschapv2";
          eap_id = "t.salverda@student.tue.nl";
        };
        children."TUE_connection" = {
          remote_ts = [ "0.0.0.0/0" "::/0" ];
        };
      };
    };
    strongswan.extraConfig = ''
      	charon {
      	  plugins {
      	    curl {
      	      redir = -1
      	      }
      	    ipseckey {
      	      enable = 1
      	      }
      	    dnscert {
      	      }
      	    }
      	  }
    '';
  };


  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # set usefull alias
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild --flake /etc/nixos?submodules=1#borma switch";
    update = "cd /etc/nixos; nix flake update --commit-lock-file";
    edit = "cd /etc/nixos; nvim .";
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
        ];


  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };
  #

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" ];
        # "bluez5.codecs" = [ "aptx" "aptx_hd" "aptx_ll" "aptx_ll_duplex" ];
      };
    };
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;
  services.hardware.bolt.enable = true;
  # hardware.xpadneo.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver intel-compute-runtime intel-vaapi-driver ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kusanagi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    hashedPassword = "$6$oLD/A.d6HHi2kKZu$zTzEKSS1aO8Fh9CC2oVYUJvNk97rla7elixI8AWFvXDJqFx3EsGR/S.rQC4ML43Va1AQWgXYCno2VFvCXwcIM0";
    packages = [
      pkgs.firefox
      pkgs.tree
      pkgs.vim
    ];
  };
  nix.settings.trusted-users = [ "kusanagi" ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1 thunderbird";
  };

  security.pam.services.hyprlock = {
    text = ''
      		auth include login
      		'';
  };
  security.pam.services.swaylock = {
    text = ''
      		auth include login
      		'';
  };
  security.pam.services.kusangi = {
    fprintAuth = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xdg-desktop-portal-hyprland
    dconf
    btrfs-progs
    libargon2
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    clang
    ffmpegthumbnailer
    f3d
    okular #to view pdf
    feh #to view images
    strongswan
    gnutls
    curl
    cifs-utils #smb mount
    powertop
    strongswanNM
    cacert.unbundled #get unbundled cacerts for strongswan
    #linuxKernel.packages.linux_xanmod.xpadneo
    sbctl #enrolling secureboot keys
  ];

  # install hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  # configuration.nix
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
    font-awesome
  ];
  security.polkit.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.nix-ld.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "weekly";
  services.btrfs.autoScrub.fileSystems = [ "/" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

