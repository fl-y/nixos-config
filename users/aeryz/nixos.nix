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
  
  users.users.aeryz = {
    isNormalUser = true;
    home = "/home/aeryz";
    extraGroups = [ "docker" "wheel" "podman"];
    shell = pkgs.zsh;
    hashedPassword = "$6$y$Jp96eqPW/MRGePaNQTMcZeC/eLenL61OdEIrac41efbXvBFtlAgSKoHwT3rKnUw/dHKDyTOOkyuOp2W/12CHf0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJRqAeEhUcBeuj/giqHR9yJj96shoXz+wuwGTfbors3 abdullaheryz@protonmail.com"
    ];
  };
}
