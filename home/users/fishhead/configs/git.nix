# Configuration for the SSH client.
{ pkgs, ...}: {

  programs = {
    git = {
      enable = true;
      userName = "Dmitrii Miroshnichenko";
      userEmail = "dm@gmail.com";

      aliases = {
        undo = "reset HEAD~1 --mixed";
        amend = "commit -a --amend";
        prv = "!gh pr view";
        prc = "!gh pr create";
        prs = "!gh pr status";
        prm = "!gh pr merge -d";
      };

      extraConfig = {
        color = {
          ui = "auto";
        };
        
        push = {
          default = "simple";
        };

        pull = {
          rebase = true;
        };

        branch = {
          autosetupmerge = true;
        };

        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519_sk_rk_git-sign.pub";
        
        safe = {
          directory = "*";
        };

        diff.tool = "vscode";
        difftool.vscode.cmd =
          let
            cmd = "code --wait --diff $LOCAL $REMOTE";
          in
          cmd;

        merge.tool = "vscode";
        mergetool.vscode.cmd =
          let
            cmd = "code --wait $MERGED";
          in
          cmd;

      };
    };
  };
}