-- claudecode.nvim plugin configuration
return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claudecode").setup({
        -- Configuration options can be added here
        -- Refer to the plugin documentation for available options
      })
    end,
  },
}