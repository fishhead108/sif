self: super: {
  # discord = super.discord.overrideAttrs (_: {
  #   src = builtins.fetchTarball
  #     "https://discord.com/api/download?platform=linux&format=tar.gz";
  # });
  # zellij = super.zellij.overrideAttrs (_: {
  #   version = "0.31.3";
  # });
  # tmux = super.tmux.overrideAttrs (_: {
  #   version = "3.1";
  # });
  # yandex-browser = super.yandex-browser.overrideAttrs (_: {
  #   version = "22.5.0.1879-1";
  #   src = builtins.fetchurl
  #     "https://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-beta/yandex-browser-beta_22.5.0.1879-1_amd64.deb";
  # });
}