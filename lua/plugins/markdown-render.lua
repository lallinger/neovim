return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  ft = { "markdown", "norg", "rmd", "org" }, -- Required to trigger lazy loading in LazyVim
  ---@module "render-markdown"
  ---@type render.md.UserConfig
  opts = {},
}
