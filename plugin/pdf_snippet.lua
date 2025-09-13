-- User command
vim.api.nvim_create_user_command("InsertPdfSnippet", function()
  require("pdf_snippet").insert_pdf_snippet()
end, {})

-- Optional keymap
vim.keymap.set("n", "<leader>ps", function()
  require("pdf_snippet").insert_pdf_snippet()
end, { desc = "Insert PDF Snippet" })
