-- This file runs automatically when the plugin is loaded
vim.api.nvim_create_user_command("InsertPdfImage", function()
  require("pdf_snippet").insert_pdf_image()
end, {})

-- Optional keymap (can be overridden by user)
vim.keymap.set("n", "<leader>pi", function()
  require("pdf_snippet").insert_pdf_image()
end, { desc = "Insert PDF Image" })
