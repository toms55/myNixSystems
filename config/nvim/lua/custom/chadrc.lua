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
-- Keybinding to run the current file with the appropriate command
vim.api.nvim_set_keymap('n', '<leader>r', ':w<CR>:lua run_current_file()<CR>', { noremap = true, silent = true })

-- Define the function to run the current file based on its type
function run_current_file()
  local filetype = vim.bo.filetype
  local filepath = vim.fn.expand('%')

  -- Python 3 file
  if filetype == 'python' then
    vim.cmd('!python3 ' .. filepath)
  -- Java file
  elseif filetype == 'java' then
    local class_name = vim.fn.expand('%:r')
    vim.cmd('!javac ' .. filepath .. ' && java ' .. class_name)
  -- C file
  elseif filetype == 'c' then
    vim.cmd('!gcc ' .. filepath .. ' -o ' .. vim.fn.expand('%:r') .. ' && ./' .. vim.fn.expand('%:r'))
  -- C++ file
  elseif filetype == 'cpp' then
    vim.cmd('!g++ ' .. filepath .. ' -o ' .. vim.fn.expand('%:r') .. ' && ./' .. vim.fn.expand('%:r'))
  -- C# file
  elseif filetype == 'cs' then
    vim.cmd('!mcs ' .. filepath .. ' && mono ' .. vim.fn.expand('%:r') .. '.exe')
  -- Rust file
  elseif filetype == 'rust' then
    vim.cmd('!cargo run')
  -- Add more filetypes here as needed
  else
    print('Filetype not supported for automatic execution.')
  end
end

vim.api.nvim_set_keymap('n', '<leader>wr', ':w<CR>:lua run_current_file()<CR>', { noremap = true, silent = true })

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
      ["<leader>r"] = { ":w<CR>:lua require'custom.chadrc'.run_current_file()<CR>", "Run current file" }
    }
  }
}

return M
