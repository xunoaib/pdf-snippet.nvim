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

## 🐍 Requirements

- Python >= 3.10
- Libraries:

  ```bash
  pip install -r python/requirements.txt
  ```
  (or manually: `pip install pdf2image pillow`)

- System Dependency: [Poppler](https://poppler.freedesktop.org) (provides `pdftopp`/`pdftocairo`)

    - Ubuntu: `sudo apt install poppler-utils`
    - Arch: `sudo pacman -S poppler`
    - macOS: `brew install poppler`
    - Windows: download Poppler binaries and add them to your `PATH`

## 📦 Installation

Using **lazy.nvim**:

```lua
{
  "xunoaib/pdf-snippet.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    -- Small helper for defining project directories
    local function project(base)
      return {
        root   = base,                   -- Project root
        pdfs   = base .. "/pdfs",        -- PDF input directory
        outdir = base .. "/extractions", -- PNG output directory
      }
    end

    require("pdf_snippet").setup({
      enable_default_keymaps = true,
      projects = {
        -- Add as many projects as you want
        data_mining = project("~/edu/course1"),
        enterprise_db = project("~/edu/course2"),
      },
    })
  end,
}
```

## 🚀 Usage

* Run manually with:

  ```
  :InsertPdfSnippet
  ```
* If `enable_default_keymaps = true`, use:

  ```
  <leader>ps
  ```
* Or define your own mapping:

  ```lua
  vim.keymap.set("n", "<leader>ps", "<cmd>InsertPdfSnippet<cr>", { desc = "Insert PDF Snippet" })
  ```


## ⚙️ Customization

The conversion logic lives in [python/extract.py](python/extract.py).
Edit this file to change options like DPI, scale factor, fonts, or annotation style.
