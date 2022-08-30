# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./machines/vm-aarch64.nix
      (import "${home-manager}/nixos")
      ./home.nix
    ];
  hardware.video.hidpi.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  environment.etc = {
    "bspwmrc".source = ./bspwm/bspwmrc;
    "sxhkdrc".source = ./bspwm/sxhkdrc;
  };

  # begin retina
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  # end retina


  # Enable the X11 windowing system.
  services.xserver = {
    autorun = true;
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
      wallpaper.mode = "fill";
    };
    displayManager = {
      defaultSession = "xfce+bspwm";
      lightdm.enable = true;
      # sessionCommands = ''
      #   eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize) 
      #   export SSH_AUTH_SOCK
      #   xr-5120
      #   ${pkgs.xorg.xset}/bin/xset r rate 200 40
      #   pamixer --set-volume 100
      #   pamixer --unmute
      #   polybar main &
      # ''; # somehow homemanager doesn't automatically start polybar
    };
    # windowManager.i3.enable = true; 
    # dpi = 96;
    dpi = 192;
    windowManager = {
      bspwm = {
        enable = true;
        configFile = "/nix-config/bspwm/bspwmrc";
        sxhkd.configFile = "/nix-config/bspwm/sxhkdrc";
      };
    };
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };

      # enable touchpad acceleration
      touchpad = {
        accelProfile = "adaptive";
      };
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    inconsolata
    inconsolata-nerdfont
    ibm-plex
  ];


  
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  virtualisation.vmware.guest.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.3
  users.users.joon = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pamixer
    rofi
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    tree
    git
    scrot
    git-lfs
    polybar
    coreutils-full
    binutils
    gnome3.gnome-control-center
    xclip
    curl
    ripgrep
    gtkmm3 # needed for the vmware user tools clipboard
    neofetch
    pinentry
    pinentry-curses
    pick-colour-picker
    kitty
    zip
    fzf
    openssh
    feh
    tdesktop
    pavucontrol # enable microphone
    (writeShellScriptBin "feh-bg-fill" ''
      feh --bg-fill /home/joon/.background-image
    '')
    (writeShellScriptBin "xr-mbp" ''
      xrandr --newmode "3024x1890_60.00"  488.50  3024 3264 3592 4160  1890 1893 1899 1958 -hsync +vsync
      xrandr --addmode Virtual-1 3024x1890_60.00
      xrandr -s 3024x1890_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-mbp-1.5" ''
      xrandr --newmode "4536x2835_60.00"  1111.25  4536 4928 5424 6312  2835 2838 2848 2935 -hsync +vsync
      xrandr --addmode Virtual-1 4536x2835_60.00
      xrandr -s 4536x2835_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-uw" ''
      xrandr --newmode "6600x2880_60.00"  1644.25  6600 7168 7896 9192  2880 2883 2893 2982 -hsync +vsync
      xrandr --addmode Virtual-1 6600x2880_60.00
      xrandr -s 6600x2880_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-5120" ''
      xrandr --newmode "5120x2880_60.00"  1275.49  5120 5560 6128 7136  2880 2881 2884 2979  -hsync +vsync
      xrandr --addmode Virtual-1 5120x2880_60.00
      xrandr -s 5120x2880_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-3840" ''
      xrandr --newmode "3840x2160_60.00"  712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync
      xrandr --addmode Virtual-1 3840x2160_60.00
      xrandr -s 3840x2160_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-5760" ''
      xrandr --newmode "5760x3240_60.00"  1619.25  5760 6264 6904 8048  3240 3243 3248 3354 -hsync +vsync
      xrandr --addmode Virtual-1 5760x3240_60.00
      xrandr -s 5760x3240_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')    
    (writeShellScriptBin "xr-6400" ''
      xrandr --newmode "6400x3600_60.00"  2003.00  6400 6968 7680 8960  3600 3603 3608 3726 -hsync +vsync
      xrandr --addmode Virtual-1 6400x3600_60.00
      xrandr -s 6400x3600_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "reload-config" ''
       sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch
    '')
    (writeShellScriptBin "composable-code" ''
      cd /home/joon/composable
      nix develop ".#main" --command code .
    '')
    (writeShellScriptBin "rentiv-code" ''
      cd /home/joon/rentiv
      nix develop --command code .
    '')
    (writeShellScriptBin "rentiv-code-site" ''
      cd /home/joon/rentiv
      nix develop --command code ./site
    '')
    (writeShellScriptBin "nixos-config-code" ''
      cd /home/joon/nixos-config
      code .
    '')
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  # services.openssh.startAgent = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
  nix.package = pkgs.nixUnstable;
 		nix.extraOptions = "experimental-features = nix-command flakes";
   			services.openssh.enable = true;
 		services.openssh.passwordAuthentication = true;
}

