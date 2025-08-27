return {
  "rmagatti/auto-session",
  config = function ()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/git", "~/Downloads", "~/Documents" },
    })

    vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "restore session for cwd" })
    vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "save session for auto session root dir" })
  end
}
