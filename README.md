# pdf-snippet.nvim

**pdf-snippet.nvim** is a Neovim plugin to extract PDF pages as images and insert them into your notes with a Markdown link.

## Features

- Select a PDF with Telescope
- Enter page number + optional label
- Calls a Python script to convert the page to an image with a source annotation
- Inserts Markdown image link at cursor

## Installation

### lazy.nvim

```lua
local function pdf_snippet_project(base)
  return {
    root   = base,  -- Used to automatically infer project root
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
        -- Adjust pat
        data_mining = pdf_snippet_project("~/edu/cis660_data_mining"),
        enterprise_db = pdf_snippet_project("~/edu/cis611_enterprise_db"),
      },
    })
  end,
}
```
