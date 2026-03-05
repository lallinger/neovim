return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<F12>",
        function()
          vim.o.paste = not vim.o.paste
          vim.notify("Paste mode: " .. (vim.o.paste and "ON" or "OFF"))
        end,
        desc = "Toggle paste mode",
      },
    },
  },
}
