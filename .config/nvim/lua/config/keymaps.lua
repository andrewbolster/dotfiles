-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Better mouse wheel scrolling in terminal
vim.keymap.set("n", "<ScrollWheelUp>", "<C-Y>", { desc = "Scroll up" })
vim.keymap.set("n", "<ScrollWheelDown>", "<C-E>", { desc = "Scroll down" })

-- Quick toggle for relative line numbers
vim.keymap.set("n", "<leader>tn", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative line numbers" })

-- Better paste in visual mode (doesn't replace clipboard)
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without replacing clipboard" })

-- Quick save with Ctrl+S (works with mouse users)
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
