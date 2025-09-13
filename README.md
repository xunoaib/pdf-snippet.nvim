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
{
  "xunoaib/pdf-snippet.nvim",
  config = function()
    -- Project directory structure helper. Tweak as needed.
    local function project(base)
      return {
        root   = base,
        pdfs   = base .. "/lectures",
        outdir = base .. "/notes/pdf_snippets",
      }
    end

    require("pdf_snippet").setup({
      enable_default_keymaps = true,
      projects = {
        -- Add as many projects as you want
        data_mining = project("~/edu/cis660_data_mining"),
        enterprise_db = project("~/edu/cis611_enterprise_db"),
      },
    })
  end,
}
```

## 🚀 Usage

* Page extraction can be manually triggered with `:InsertPdfSnippet`
* If `enable_default_keymaps = true`, `<leader>ps` will also trigger extraction.
* You can also define your own keymap:

```lua
vim.keymap.set("n", "<leader>ps", "<cmd>InsertPdfSnippet<cr>", { desc = "Insert PDF Snippet" })
```
