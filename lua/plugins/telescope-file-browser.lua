return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      extensions = {
        file_browser = {
          hidden = true,
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      },
    })
  end,
}
