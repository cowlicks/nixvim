{
  # Import all your configuration modules here
  colorschemes.gruvbox.enable = true;
  plugins = {
    treesitter.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "utilsnips"; }
        { name = "tmux"; }
      ];
    };
    cmp-nvim-lsp.enable = true;
    nix.enable = true;
    lsp-format.enable = true;
    lsp = {
    keymaps = {
        lspBuf = {
          gr = "references";
          gd = "definition";
        };
      };
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
    telescope = {
      enable = true;
       extensions = {
        live-grep-args.enable = true;
      };
      keymaps = {
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
          "<leader>fg" = "live_grep";
      };
    };
  };
  extraConfigLua = builtins.readFile ./vimrc.lua;
  extraConfigVim = builtins.readFile ./vimrc;
}
