local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move lines down in visual mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move lines up in visual mode" })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up with cursor centered" })

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "clear search highlight", silent = true })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "x", '"_x', opts)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "replace word under cursor globally" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "makes file executable", silent = true })

-- hl yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "close current split" })

vim.keymap.set("n", "<leader>fp", function()
  local filepath = vim.fn.expand("%:~")
  vim.fn.setreg("+", filepath)
  print("filepath copied to clipboard: " .. filepath)
end, { desc = "copy filepath to clipboard" })
