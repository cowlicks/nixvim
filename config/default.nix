{
  # Import all your configuration modules here
  colorschemes.gruvbox.enable = true;

  plugins = {
  nix.enable = true;
  lsp-format.enable = true;
  lsp = {
    enable = true;
    servers = {
      rust-analyzer = {
        installCargo = true;
        installRustc = true;
        enable = true;
      };
      # should be ts-ls according to
      # https://nix-community.github.io/nixvim/plugins/lsp/servers/ts-ls/index.html
      tsserver = {
        enable = true;
      };
      nixd = {
        enable = true;
      };
    };
  };
  };
  extraConfigLua = builtins.readFile ./vimrc.lua;
  extraConfigVim = builtins.readFile ./vimrc;
}
