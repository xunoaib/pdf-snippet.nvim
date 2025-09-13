# pdf-snippet.nvim

**pdf-snippet.nvim** is a Neovim plugin for quickly extracting pages from PDFs
as images and inserting them into your notes with a Markdown link.

Perfect for lecture notes, research annotations, or any workflow where you want
direct visual snippets from your PDFs.

## ✨ Features

- Select a PDF with Telescope
- Enter a page number (with optional label)
- Converts the page to an image via a bundled Python script
- Inserts a Markdown image link at your cursor
- Each image is named and annotated with the source PDF and page number

## 📦 Installation

Using **lazy.nvim**:

```lua
-- Helper function to define project paths
local function pdf_snippet_project(base)
  return {
    root   = base,  -- Project root
    pdfs   = base .. "/lectures",  -- PDF input directory
    outdir = base .. "/notes/pdf_snippets",  -- Image output directory
  }
end
```

```lua
{
  "xunoaib/pdf-snippet.nvim",
  config = function()
    require("pdf_snippet").setup({
      projects = {
        -- Add as many projects as you want
        data_mining = pdf_snippet_project("~/edu/cis660_data_mining"),
        enterprise_db = pdf_snippet_project("~/edu/cis611_enterprise_db"),
      },
    })
  end,
}
```
