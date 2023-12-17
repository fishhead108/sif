# The configuration for neovim.
{ config
, ...
}:
let
  # The full path to the current neovim.
  neovim = "${config.home.profileDirectory}/bin/nvim";
in
{
  imports = [
    ./base.nix
    ./codesmarts.nix
    ./filetypes
    # ./git.nix
    ./tags.nix
    ./theme.nix
    ./utils.nix
  ];

  # Use neovim as the default editor.
  #home.sessionVariables.EDITOR = "${config.home.profileDirectory}/bin/nvim";

  # Add shell aliases for various vim modes.
  home.shellAliases = {
    # Compatibility aliases for the basic vim commands.
    ex = "${neovim} -e";
    #vi = "${neovim}";
    view = "${neovim} -R";
   # vim = "${neovim}";
    vimdiff = "${neovim} -d";

    # Compatibility aliases for the restricted-mode vim commands.
    rview = "${neovim} -Z -R";
    rvim = "${neovim} -Z";

    # Aliases for modes that nvim doesn't provide symlinks for like vim.
    nex = "${neovim} -e";
    nrview = "${neovim} -Z -R";
    nrvim = "${neovim} -Z";
    nvi = "${neovim}";
    nview = "${neovim} -R";
    nvimdiff = "${neovim} -d";
    rnview = "${neovim} -Z -R";
    rnvim = "${neovim} -Z";
  };

  # Enable neovim.
  programs.neovim.enable = true;

  # Enable Python support.
  programs.neovim.withPython3 = true;

  # Enable Node support.
  programs.neovim.withNodeJs = true;

  # Enable Ruby support.
  programs.neovim.withRuby = true;

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
}
