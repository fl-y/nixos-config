{ config, lib, pkgs, ... }:
let 
in
{
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = with pkgs; [
    fd
    firefox
    fzf
    htop
    jq
    ripgrep
    ranger
    tree
    watch
    kitty
    openssh
    feh
    zip
    rnix-lsp
    curl
    pamixer
    wget
    git
    scrot
    git-lfs
    coreutils-full
    binutils
    gnome3.gnome-control-center
    xclip
    gtkmm3 # needed for the vmware user tools clipboard
    neofetch
    pinentry
    pinentry-curses
    pick-colour-picker
    vscode
    helix
    bottom
    tdesktop
    lazygit
    element-desktop
    (writeShellScriptBin "feh-bg-fill" ''
      feh --bg-fill /home/joon/.background-image
    '')
  ];


  home.file.".background-image".source = ../../wallpapers/purple.png;
  home.file."Screenshots/.keep".source = ./.keep;
  home.file.".config/helix/config.toml".source = ./helix.toml;
  home.file.".config/helix/languages.toml".source = ./languages.toml;

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  # home.sessionVariables = {
  #   LANG = "en_US.UTF-8";
  #   LC_CTYPE = "en_US.UTF-8";
  #   LC_ALL = "en_US.UTF-8";
  #   EDITOR = "nvim";
  #   PAGER = "less -FirSwX";
  #   MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  # };

  # home.file.".gdbinit".source = ./gdbinit;
  # home.file.".inputrc".source = ./inputrc;

  # xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  # xdg.configFile."devtty/config".text = builtins.readFile ./devtty;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  # programs.bash = {
  #   enable = true;
  #   shellOptions = [];
  #   historyControl = [ "ignoredups" "ignorespace" ];
  #   # initExtra = builtins.readFile ./bashrc;
  # };

  programs.direnv = {
    enable = true;

    # config = {
    #   whitelist = {
    #     prefix= [
    #       "$HOME/code/go/src/github.com/hashicorp"
    #       "$HOME/code/go/src/github.com/mitchellh"
    #     ];

    #     exact = ["$HOME/.envrc"];
    #   };
    # };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    secureSocket = false;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 1000000;
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [ pain-control ];
    extraConfig = ''
      set -g mouse on
    '';
  };   

  programs.git = {
    enable = true;
    userName = "joon";
    userEmail = "thedigitalimg@gmail.com";
    lfs.enable = true;
    signing = {
      signByDefault = true;
      key = "06A6337C2BDD1365883C0668DB347466107E589F";
    };
    extraConfig = {
      # branch.autosetuprebase = "always";
      color.ui = true;
      # core.askPass = ""; # needs to be empty to use terminal for ask pass
      # credential.helper = "store"; # want to make this more secure
      github.user = "joon";
      # push.default = "tracking";
      # init.defaultBranch = "main";
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      "gcbommkclmclpchllfjekcdonpmejbdp" # Https everywhere
      "bkdgflcldnnnapblkhphbgpggdiikppg" # DuckDuckGo
      "ennpfpdlaclocpomkiablnmbppdnlhoh" # Rust Search Extension
      "mjdepdfccjgcndkmemponafgioodelna" # DF Tube (Distraction Free for YouTube)
      "dneaehbmnbhcippjikoajpoabadpodje" # Old reddit redirect
      "ililagkodjpoopfjphagpamfhfbamppa" # Less distracting reddit
      "blaaajhemilngeeffpbfkdjjoefldkok" # LeechBlock
    ];
  };

  programs.zsh = {
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "git"
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "prompt"
      ];
    };
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      icat = "kitty +kitten icat";
      lg = "lazygit";
      pbcopy = "xclip -selection c"; # macOS' pbcopy equivalent
    };
    initExtra = ''
      if [ -n "''${commands[fzf-share]}" ]; then
        source "''$(fzf-share)/key-bindings.zsh"
        source "''$(fzf-share)/completion.zsh"
      fi
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "06A6337C2BDD1365883C0668DB347466107E589F";
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = ./rofi;
    plugins = [ pkgs.rofi-emoji ];
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
  };


  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      mpdSupport = true;
      pulseSupport = true;
    };
    config = ./polybar.ini;
    script = ''
      polybar main &
    '';
  };


  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
