{
 config,
 pkgs,
 lib,
 ...
}: {
 nixpkgs.overlays = [
   (final: prev: {
     chat-gpt = pkgs.stdenv.mkDerivation rec {
       name = "chat-gpt";
       version = "v0.12.0";

       src = pkgs.fetchurl {
         url = "https://github.com/lencx/ChatGPT/releases/download/${version}/ChatGPT_0.12.0_linux_x86_64.deb";
         sha256 = "d8a0daa8b55823f81236f71dd1fa4eb5989fd6fb2392fa3bb0a2b023feaf8cef";
       };

       buildInputs = [pkgs.dpkg pkgs.tree];

       sourceRoot = ".";
       unpackCmd = "dpkg-deb -x $src .";

       dontConfigure = true;
       dontBuild = true;


       installPhase = ''
         mkdir -p $out/bin
         cp  usr/bin/chat-gpt $out/bin
       '';
       preFixup = let
         # found all these libs with `patchelf --print-required` and added them so that they are dynamically linked
         libPath = lib.makeLibraryPath [
           pkgs.webkitgtk
           pkgs.gtk3
           pkgs.pango
           pkgs.cairo
           pkgs.gdk-pixbuf
           pkgs.glib
           pkgs.openssl_1_1
         ];
       in ''
         patchelf \
           --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
           --set-rpath "${libPath}" \
           $out/bin/chat-gpt
       '';

       meta = with lib; {
         homepage = https://github.com/lencx/ChatGPT/;
         description = "ChatGPT Desktop Application (Mac, Windows and Linux)";
         license = licenses.unfree;
         platforms = platforms.linux;
       };
     };
   })
 ];
}