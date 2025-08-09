require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local function run_current_file()
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

-- Add your custom mappings
map("n", "<leader>r", function()
  vim.cmd('w')
  run_current_file()
end, { desc = "Run current file" })

map("n", "<leader>wr", function()
  vim.cmd('w')
  run_current_file()
end, { desc = "Write and run current file" })
