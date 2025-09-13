-- User command
vim.api.nvim_create_user_command("InsertPdfSnippet", function()
  require("pdf_snippet").insert_pdf_snippet()
end, {})
