return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- Ensure ensure_installed exists
      opts.ensure_installed = opts.ensure_installed or {}

      -- Filter out lua_ls from mason-lspconfig specifically
      opts.ensure_installed = vim.tbl_filter(function(server)
        return server ~= "lua_ls"
      end, opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          mason = false,
          cmd = { vim.fn.expand("$HOME/go/bin/terraform-ls"), "serve" },
        },
        lua_ls = {
          mason = false,
          cmd = { "lua-language-server" },
        },
      },
    },
  },
}
