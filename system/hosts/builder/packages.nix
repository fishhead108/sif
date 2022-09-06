{ pkgs, ... }: {

    programs.gnupg.agent.enable = false;
    environment.shellInit = "";
}
