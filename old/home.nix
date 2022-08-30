{ config, pkgs, lib, ... }:

{
  home-manager.users.joon = {
    home.file.".background-image".source = ./wallpapers/purple.png;

    gtk = {
      enable = true;
      # theme = {
      #    name = "Vertex-Dark";
      #    package = pkgs.theme-vertex;
      # };
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

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 36000;
      maxCacheTtl = 36000;
      defaultCacheTtlSsh = 36000;
      maxCacheTtlSsh = 36000;
      enableSshSupport = true;
      pinentryFlavor = "curses";
    };  

    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      # theme = /etc/nixos/rofi/theme.rafi;
      plugins = [ pkgs.rofi-emoji ];
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = (with pkgs.vscode-extensions; [
        bbenoist.nix
        file-icons.file-icons
        svelte.svelte-vscode
        bradlc.vscode-tailwindcss
        golang.go
        github.github-vscode-theme
        github.copilot
        matklad.rust-analyzer
        eamodio.gitlens
        bungcip.better-toml
        ms-vsliveshare.vsliveshare
        streetsidesoftware.code-spell-checker
        kahole.magit
        formulahendry.auto-rename-tag
        eg2.vscode-npm-script
        davidanson.vscode-markdownlint
        ms-azuretools.vscode-docker
        vadimcn.vscode-lldb
      ])
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
        name = "expand-region";
        publisher = "letrieu";
        version = "0.1.4";
        sha256 = "U4AYq7ONdmP2PaLU/OapN8Ocq2ZE3ORTvhkXVwqPqZs=";
      } 
      {
        name = "vscode-thunder-client";
        publisher = "rangav";
        version = "1.14.4";
        sha256 = "fCwSLLoVuyXOfLyd7cmBzQQ8XYXYYV1o031p9L9rR3A=";
      }];
      userSettings = lib.importJSON ./vscode/settings.json;
      keybindings = lib.importJSON ./vscode/keybindings.json;
    };

    programs.kitty.settings = ./kitty/kitty.conf;
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        mpdSupport = true;
        pulseSupport = true;
      };
      config = ./polybar/polybar.ini;
      script = ''
        polybar main &
      '';
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

    xresources.properties = {
      "Xft.dpi" = 192;
      
    };
  };

}

