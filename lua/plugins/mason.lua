return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Add both variations just to be safe
      local unsupported = { "stylua", "lua-language-server", "lua_ls", "terraformls" }
      opts.ensure_installed = opts.ensure_installed or {}

      local filtered = {}
      for _, pkg in ipairs(opts.ensure_installed) do
        local is_unsupported = false
        for _, unsupp_name in ipairs(unsupported) do
          if pkg == unsupp_name then
            is_unsupported = true
            break
          end
        end
        if not is_unsupported then
          table.insert(filtered, pkg)
        end
      end
      opts.ensure_installed = filtered
    end,
  },
}
