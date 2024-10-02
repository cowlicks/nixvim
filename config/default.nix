{
  # Import all your configuration modules here
  colorschemes.gruvbox.enable = true;

  plugins.lsp = {
    enable = true;
    servers = {
      rust-analyzer = {
        installCargo = true;
        installRustc = true;
        enable = true;
      };
      nixd = {
        enable = true;
      };
    };
  };
  extraConfigVim = builtins.readFile ./vimrc;
}
