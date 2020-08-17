local api = vim.api
local ts = vim.treesitter

local queries = require'nvim-treesitter.query'
local parsers = require'nvim-treesitter.parsers'
local configs = require'nvim-treesitter.configs'
local ts_utils = require'nvim-treesitter.ts_utils'
local locals = require'nvim-treesitter.locals'

local M = {}
local hlmap = vim.treesitter.highlighter.hl_map
local semantic_hlns = api.nvim_create_namespace("ts-semantic-highlights")

M.highlight_semantics = ts_utils.memoize_by_buf_tick(function(bufnr)
  local matches = queries.get_matches(bufnr, 'semantic_highlights')

  api.nvim_buf_clear_namespace(bufnr, semantic_hlns, 0, -1)

  for _, match in ipairs(matches) do
    locals.recurse_local_nodes(match, function(_, node, hl_type)
      local higroup = hlmap[hl_type]
      local start_row, start_col, end_row, end_col = node:range()

      if higroup then
        vim.highlight.range(bufnr, semantic_hlns, higroup, { start_row, start_col }, { end_row, end_col }, "c", true)
      end
    end)
  end
end)

function M.attach(bufnr, lang)
  local bufnr = bufnr or api.nvim_get_current_buf()
  local lang = lang or parsers.get_buf_lang(bufnr)

  vim.cmd(string.format([[autocmd CursorHold <buffer=%d> lua require'nvim-treesitter.semantic_highlight'.highlight_semantics(%d)]], bufnr, bufnr))
end

function M.detach(bufnr)
  local buf = bufnr or api.nvim_get_current_buf()
end

return M
