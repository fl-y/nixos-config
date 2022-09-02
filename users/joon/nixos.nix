{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  # environment.pathsToLink = [ "/share/fish" ];
  
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    # liberation_ttf
    ibm-plex
    fira-code
    fira-code-symbols
    # mplus-outline-fonts
    # dina-font
    # proggyfonts
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

    # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
    helix
    # wpgtk
    # dconf
  ];
 
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  
  users.users.joon = {
    isNormalUser = true;
    home = "/home/joon";
    extraGroups = [ "docker" "wheel" "podman"];
    shell = pkgs.zsh;
    hashedPassword = "$6$asd$0/6GQ5GeBmXwBVvAEkOo./DNr4.bUzCr3FdcMDyRaNmBjdSi6lMMl6tDICpvNgbPSeLe9MA/sQEyxjcYM5So./";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJpS4zCMeOKKAIWk5LhBEkJ8ADFYkTsG9BtkUokpePW thedigitalimg@gmail.com"
    ];
  };
}
