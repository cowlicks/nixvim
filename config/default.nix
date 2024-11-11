{
  # Import all your configuration modules here
  colorschemes.gruvbox.enable = true;
  plugins = {
    trouble = {
      enable = true;
    };
    web-devicons.enable = true;
    flash = {
      enable = true;
    };
    rustaceanvim = {
      enable = true;
    };
    treesitter.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "luasnip";}
          { name = "tmux"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "nvim_lsp_document_symbol"; }
        ];
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
    nix.enable = true;
    lsp-format = {
      enable = true;
      settings = {
          javascript = {
            exclude = [ "ts_ls" ];
          };
      };
    };
    lsp = {
      keymaps = {
          lspBuf = {
            gr = "references";
            gd = "definition";
          };
      };
      enable = true;
      servers = {
        clangd = {
          enable = true;
        };
        # Removed in favor of rustaceanvim
        #rust_analyzer = {
        #  installCargo = true;
        #  installRustc = true;
        #  enable = true;
        #};
        # should be ts-ls according to
        # https://nix-community.github.io/nixvim/plugins/lsp/servers/ts-ls/index.html
        ts_ls = {
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
  keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>";
    }
    {
      mode = "n";
      key = "<leader>te";
      action = "<cmd>Trouble diagnostics toggle focus=true filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<cr>";
    }
  ];
}
