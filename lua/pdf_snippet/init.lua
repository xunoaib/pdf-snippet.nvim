local M = {}

-- resolve plugin root (works regardless of where installed)
local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")

M.config = {
  enable_default_keymaps = true,
  projects = {}, -- user defines projects
  script = plugin_root .. "/python/extract.py",
}

--- Setup user configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- define default keymap here
  if M.config.enable_default_keymaps then
    vim.keymap.set("n", "<leader>ps", function()
      require("pdf_snippet").insert_pdf_snippet()
    end, { desc = "Insert PDF Snippet" })
  end
end

--- Try to detect project from current buffer path
local function detect_project()
  local buf_path = vim.fn.expand("%:p")
  for name, project in pairs(M.config.projects) do
    local root = vim.fn.expand(project.root)
    if buf_path:find(root, 1, true) == 1 then
      return project
    end
  end
  return nil
end

--- Let user pick a project manually
local function select_project(callback)
  vim.ui.select(vim.tbl_keys(M.config.projects), { prompt = "Select project:" }, function(choice)
    if not choice then return end
    callback(M.config.projects[choice])
  end)
end

--- Main entry
function M.insert_pdf_snippet()
  if vim.tbl_isempty(M.config.projects) then
    vim.notify("pdf-snippet: no projects configured", vim.log.levels.ERROR)
    return
  end

  local project = detect_project()
  if not project then
    -- fallback
    return select_project(function(p)
      M._insert_for_project(p)
    end)
  end

  return M._insert_for_project(project)
end

--- Core implementation for a given project
function M._insert_for_project(project)
  local pdfs_dir = vim.fn.expand(project.pdfs)
  local outdir = vim.fn.expand(project.outdir)

  local telescope = require("telescope.builtin")
  telescope.find_files({
    prompt_title = "Select PDF",
    cwd = pdfs_dir,
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
          if not page or page == "" then
            vim.schedule(function() vim.cmd("stopinsert") end)
            return
          end
          vim.schedule(function() vim.cmd("startinsert") end)

          vim.ui.input({ prompt = "Label: ", default = pdf_name }, function(label)
            if not label then
              vim.schedule(function() vim.cmd("stopinsert") end)
              return
            end
            vim.schedule(function() vim.cmd("startinsert") end)

            local cmd = {
              "python3", M.config.script, pdf, page,
              "--outdir", outdir,
            }
            if label and label ~= "" and label ~= pdf_name then
              vim.list_extend(cmd, { "--label", label })
            end

            local output = vim.fn.trim(vim.fn.system(cmd))
            local lines = vim.split(output, "\n", { plain = true, trimempty = true })

            local row = vim.api.nvim_win_get_cursor(0)[1]
            local buf = vim.api.nvim_get_current_buf()

            -- insert below current line
            vim.api.nvim_buf_set_lines(buf, row, row, false, lines)

            -- move cursor to start of first inserted line
            vim.api.nvim_win_set_cursor(0, { row + 1, 0 })

            -- -- move cursor after the snippet text
            -- local new_line = lines[#lines] or ""
            -- vim.api.nvim_win_set_cursor(0, { row + #lines, #new_line })

            vim.schedule(function() vim.cmd("stopinsert") end)
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
