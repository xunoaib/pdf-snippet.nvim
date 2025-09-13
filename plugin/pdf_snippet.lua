-- User command
vim.api.nvim_create_user_command("InsertPdfSnippet", function()
  require("pdf_snippet").insert_pdf_snippet()
end, {})

-- only define keymap if user sets opts.keymaps = true
local config = require("pdf_snippet").config
if config.enable_default_keymaps then
  vim.keymap.set("n", "<leader>ps", function()
    require("pdf_snippet").insert_pdf_snippet()
  end, { desc = "Insert PDF Snippet" })
end
