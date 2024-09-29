{
  # Import all your configuration modules here
  imports = [ ./bufferline.nix ];
  colorschemes.gruvbox.enable = true;

  plugins.lsp = {
        enable = true;
        servers = {
          rust-analyzer = {
            installCargo = true;
            installRustc = true;
            enable = true;

          };
        };
      };
  };
  extraConfigVim = builtins.readFile ./vimrc;
}
