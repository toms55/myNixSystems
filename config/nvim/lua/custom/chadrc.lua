-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 
---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "tokyonight",
    -- hl_override = {
    --   Comment = { italic = true },
    --   ["@comment"] = { italic = true },
    -- },
}

-- Define the function to run the current file
function run_current_file()
  local filetype = vim.bo.filetype
  local filepath = vim.fn.expand('%')
  local filename = vim.fn.expand('%:r')
  
  if filetype == 'python' then
    vim.cmd('!python3 "' .. filepath .. '"')
  elseif filetype == 'java' then
    vim.cmd('!javac "' .. filepath .. '" && java ' .. filename)
  elseif filetype == 'c' then
    vim.cmd('!gcc "' .. filepath .. '" -o "' .. filename .. '" && ./' .. filename)
  elseif filetype == 'cpp' then
    vim.cmd('!g++ "' .. filepath .. '" -o "' .. filename .. '" && ./' .. filename)
  elseif filetype == 'cs' then
    vim.cmd('!mcs "' .. filepath .. '" && mono "' .. filename .. '.exe"')
  elseif filetype == 'rust' then
    vim.cmd('!cargo run')
  else
    print('Filetype not supported for automatic execution.')
  end
end

M.mappings = {
  general = {
    n = {
      ["<leader>r"] = { ":w<CR>:lua run_current_file()<CR>", "Run current file" },
      ["<leader>wr"] = { ":w<CR>:lua run_current_file()<CR>", "Write and run current file" }
    }
  }
}

M.nvdash = {
  load_on_startup = false
}

-- This is where you add your vim options
vim.opt.relativenumber = true      -- Enable relative line numbers
vim.opt.number = true              -- Show current line number
vim.opt.colorcolumn = "100"        -- Show visual guide at column 130
vim.opt.textwidth = 100            -- Wrap text at 130 chars with `gq` or in comments

return M
