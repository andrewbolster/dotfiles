-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure mouse support is enabled (LazyVim default but explicit)
vim.opt.mouse = "a"

-- Ensure line numbers are configured (LazyVim default but explicit)
vim.opt.number = true
vim.opt.relativenumber = true

-- Performance optimizations for SSH/remote terminals
vim.opt.lazyredraw = true        -- Don't redraw during macros/commands
vim.opt.ttyfast = true           -- Indicate fast terminal for more characters sent at once
vim.opt.regexpengine = 1         -- Use old regex engine (faster for some cases)
vim.opt.synmaxcol = 200          -- Limit syntax highlighting to first 200 columns
vim.opt.updatetime = 300         -- Faster completion (default 4000ms)

-- Better visual experience
vim.opt.cursorline = true        -- Re-enable cursor line for better visibility
vim.opt.colorcolumn = "80"       -- Show column guide at 80 characters
vim.opt.scrolloff = 8            -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8        -- Keep 8 columns visible left/right of cursor

-- Better search experience
vim.opt.ignorecase = true        -- Ignore case in search
vim.opt.smartcase = true         -- Case-sensitive if uppercase letters present
vim.opt.hlsearch = true          -- Highlight search results
vim.opt.incsearch = true         -- Show search matches as you type

-- Clipboard integration
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
