return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "franco-ruggeri/codecompanion-spinner.nvim",
  },
  keys = {
    { "<A-q>", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n" }, desc = "CodeCompanion Chat" },
    { "<A-q>", "<cmd>:CodeCompanionChat Toggle<cr>", mode = { "i" }, desc = "CodeCompanion Chat" },
    { "<A-q>", ":CodeCompanionChat Add<cr>i", mode = { "v" }, desc = "CodeCompanion Chat" },
    { "<A-Q>", ":CodeCompanion<cr>", mode = { "v" }, desc = "CodeCompanion File" },
    { "<A-Q>", "<cmd>CodeCompanion<cr>", mode = { "n", "i" }, desc = "CodeCompanion File" },
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "gemini",
        },
      },
      adapters = {
        gpt5 = function()
          return require("codecompanion.adapters").extend("openai", {
            name = "gpt5",
            env = {
              api_key = os.getenv("OPENAI_API_KEY"),
            },
            schema = {
              model = {
                default = "gpt-5-mini",
              },
            },
          })
        end,

        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            name = "gemini",
            env = {
              api_key = os.getenv("GEMINI_API_KEY"),
            },
            schema = {
              model = {
                default = "gemini-3.1-pro-preview",
              },
            },
          })
        end,
      },
      display = {
        chat = {
          show_settings = true,
          render_headers = true,
        },
      },
      extensions = {
        spinner = {},
      },
    })
  end,
}
