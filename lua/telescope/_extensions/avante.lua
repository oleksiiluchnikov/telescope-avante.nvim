local has_telescope = pcall(require, "telescope")
if not has_telescope then
	error("telescope-avante.nvim requires telescope.nvim - https://github.com/nvim-telescope/telescope.nvim")
end
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local themes = require("telescope.themes")
local conf = require("telescope.config").values

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("This plugin requires nvim-telescope/telescope.nvim")
end

local M = {}

-- Get current avante provider
local function get_current_provider()
	return vim.g.avante_provider or ""
end

function M.avante(opts)
	-- Merge user opts with dropdown theme
	opts = vim.tbl_deep_extend(
		"force",
		themes.get_dropdown({
			width = 0.3,
			previewer = false,
			prompt_title = false,
			results_title = false,
			winblend = 10,
		}),
		opts or {}
	)

	local current_provider = get_current_provider()

	pickers
		.new(opts, {
			finder = finders.new_table({
				results = require("avante.config").providers,
				entry_maker = function(provider)
					return {
						value = provider,
						display = provider .. (provider == current_provider and " " or ""),
						ordinal = provider,
					}
				end,
			}),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if not selection then
						return
					end
					require("avante.api").switch_provider(vim.trim(selection.value))
				end)
				return true
			end,
		})
		:find()
end

return require("telescope").register_extension({
	exports = {
		avante = M.avante,
	},
})
