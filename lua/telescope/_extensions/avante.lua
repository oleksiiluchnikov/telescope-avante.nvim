---@mod telescope-avante Telescope picker for Avante providers
---@brief [[
--- A telescope extension for switching between Avante providers
--- with an elegant minimal UI.
---@brief ]]

-- Dependencies check
local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("telescope-avante.nvim requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end

local has_avante, _ = pcall(require, "avante")
if not has_avante then
	error("telescope-avante.nvim requires avante.nvim (https://github.com/yetone/avante.nvim)")
end

-- Telescope modules
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local themes = require("telescope.themes")

local THEME = {
	width = 0.25, -- 25% of screen width
	height = 0.35, -- 35% of screen height
	winblend = 10, -- Slight transparency
	border = true, -- Show border
	previewer = false, -- No previewer needed
	prompt_title = false,
	results_title = false,
}

local M = {}

-- Get current avante provider with fallback
---@return string
local function get_current_provider()
	return vim.g.avante_provider or ""
end

---@param opts table|nil
function M.avante(opts)
	-- Merge user opts with our elegant theme
	opts = vim.tbl_deep_extend("force", themes.get_dropdown(THEME), opts or {})

	local current = get_current_provider()

	pickers
		.new(opts, {
			finder = finders.new_table({
				results = require("avante.config").providers,
				entry_maker = function(provider)
					return {
						value = provider,
						display = provider,
						ordinal = provider,
					}
				end,
			}),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection and selection.value ~= current then
						require("avante.api").switch_provider(selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

-- Register telescope extension
return telescope.register_extension({
	exports = {
		avante = M.avante,
	},
})
