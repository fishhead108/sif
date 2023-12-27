{ config, pkgs, lib, ... }:

{
    programs = {

      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "fishhead" ];
      };
      
      # Enable NeoVim
      neovim.enable = true;

      # Enable GO language
      go.enable = true;

      # Whether interactive shells should show which Nix package (if any) provides a missing command.
      command-not-found.enable = true;
      
      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      git = {
        extraConfig = { 
          safe = {
          directory = "*";
          };
        };
        enable = true;
        userName = "Dmitrii Miroshnichenko";
        userEmail = "dm@revizto.com";
        signing = {
          key = "43005EF80787DE60";
          signByDefault = true;
        };
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
          ll = "ls -l";
          update = "sudo nixos-rebuild switch";
        };
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
        };
        oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "robbyrussell";
        };
        initExtraFirst = ''
          [ ! -d "$HOME/.zsh/fsh/" ] && mkdir $HOME/.zsh/fsh/
          export FAST_WORK_DIR=$HOME/.zsh/fsh/;
          export PATH=$PATH:~/tools:
          export PATH=$PATH:~/.npm-global/bin
          export PATH=$PATH:~/.bin
        '';
        initExtra = ''
          bindkey '^[[1;5C' forward-word
          bindkey '^[[1;5D' backward-word
        '';
        plugins = [
          {
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.6.4";
              sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
            };
          }
          {
            name = "fast-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zdharma";
              repo = "fast-syntax-highlighting";
              rev = "v1.55";
              sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
            };
          }
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "powerlevel10k-config";
            src = lib.cleanSource ./p10k-config;
            file = "p10k.zsh";
          }
        ];
      };
    };
}
