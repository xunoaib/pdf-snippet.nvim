local M = {}

M.config = {
  root = vim.fn.expand("~") .. "/edu/cis660_data_mining",
  script = vim.fn.expand("~") .. "/edu/cis660_data_mining/scripts/extract_pdf_page_image.py",
  outdir = vim.fn.expand("~") .. "/edu/cis660_data_mining/notes/pdf_images",
}

--- Setup user configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

--- Insert a PDF page as an annotated image
function M.insert_pdf_image()
  local cfg = M.config
  local lectures_dir = cfg.root .. "/lectures"

  local telescope = require("telescope.builtin")
  telescope.find_files({
    prompt_title = "Select PDF",
    cwd = lectures_dir,
    find_command = { "fd", "--type", "f", "--extension", "pdf" },
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function select_pdf(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not selection or not selection.path then return end

        local pdf = selection.path
        local pdf_name = vim.fn.fnamemodify(pdf, ":t")

        vim.ui.input({ prompt = "Page number: " }, function(page)
          if not page or page == "" then return end
          vim.schedule(function() vim.cmd("startinsert") end)

          vim.ui.input({ prompt = "Label (optional): ", default = pdf_name }, function(label)
            local label_arg = ""
            if label and label ~= "" and label ~= pdf_name then
              label_arg = string.format("--label %q", label)
            end

            local cmd = string.format(
              "python3 %s %s %s --outdir %s %s",
              cfg.script, pdf, page, cfg.outdir, label_arg
            )
            local output = vim.fn.trim(vim.fn.system(cmd))
            local lines = vim.split(output, "\n", { plain = true, trimempty = true })

            local row = vim.api.nvim_win_get_cursor(0)[1]
            local buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_lines(buf, row, row, false, lines)

            vim.cmd("stopinsert")
          end)
          vim.schedule(function() vim.cmd("startinsert") end)
        end)

        vim.schedule(function() vim.cmd("startinsert") end)
      end

      map("i", "<CR>", select_pdf)
      map("n", "<CR>", select_pdf)
      return true
    end,
  })
end

return M
