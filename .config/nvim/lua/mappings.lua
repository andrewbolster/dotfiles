require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "e",  "<cmd>NvimTreeToggle<cr>", { desc = "Explorer"})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
