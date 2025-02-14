---@mod telescope-avante Telescope picker for Avante providers
---@brief [[
--- A telescope extension for switching between Avante providers.
--- Provides an elegant UI for selecting and switching AI providers.
---
--- Usage:
--- ```lua
--- require('telescope').load_extension('avante')
--- -- Then use:
--- :Telescope avante
--- ```
---@brief ]]
---@diagnostic disable: unused-local

-- Dependencies check
local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("`telescope-avante.nvim` requires `telescope.nvim` (https://github.com/nvim-telescope/telescope.nvim)")
end

local has_avante, _ = pcall(require, "avante")
if not has_avante then
	error("`telescope-avante.nvim` requires `avante.nvim` (https://github.com/yetone/avante.nvim)")
end

-- Telescope modules
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")

-- Default configuration
local defaults = {
	theme = "dropdown",
	previewer = false,
	prompt_title = "Avante Providers",
	results_title = false,
	border = true,
	sorting_strategy = "ascending",
	layout_strategy = "center",
	mappings = {
		i = {
			["<CR>"] = "select_default",
			["<C-c>"] = "close",
			["<Esc>"] = "close",
		},
		n = {
			["<CR>"] = "select_default",
			["q"] = "close",
			["<Esc>"] = "close",
		},
	},
}

local function make_display(entry)
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 2 }, -- Width for the checkmark
			{ remaining = true }, -- Provider name takes remaining space
		},
	})

	return displayer({
		{ entry.current and "✓" or " " },
		entry.value,
	})
end

local M = {}

---@param opts table|nil: Configuration options
function M.avante(opts)
	opts = vim.tbl_deep_extend("force", defaults, opts or {})

	if opts.theme then
		if opts.theme == "dropdown" then
			opts = vim.tbl_deep_extend("force", opts, require("telescope.themes").get_dropdown())
		elseif opts.theme == "cursor" then
			opts = vim.tbl_deep_extend("force", opts, require("telescope.themes").get_cursor())
		elseif opts.theme == "ivy" then
			opts = vim.tbl_deep_extend("force", opts, require("telescope.themes").get_ivy())
		end
	end
	local results = require("avante.config").providers

	-- Calculate the width based on the longest provider name
	local max_width = 0
	for _, provider in ipairs(results) do
		max_width = math.max(max_width, vim.fn.strdisplaywidth(provider))
	end

	-- Set dimensions
	opts.height = #results + 2
	opts.width = max_width + 6 -- Add space for checkmark (2) and padding (4)

	-- Add specific layout configuration
	opts.layout_config = vim.tbl_extend("force", opts.layout_config or {}, {
		width = opts.width,
		height = opts.height,
		prompt_position = "top",
	})

	local current_provider = require("avante.config").provider

	pickers
		.new(opts, {
			prompt_title = opts.prompt_title,
			finder = require("telescope.finders").new_table({
				results = results,
				entry_maker = function(provider)
					return {
						value = provider,
						display = make_display,
						ordinal = provider,
						current = provider == current_provider,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection and selection.value ~= current_provider then
						require("avante.api").switch_provider(selection.value)
					end
				end)

				-- Add custom mappings
				for mode, mode_mappings in pairs(opts.mappings) do
					for key, action in pairs(mode_mappings) do
						map(mode, key, actions[action])
					end
				end

				return true
			end,
			previewer = opts.previewer,
			sorting_strategy = opts.sorting_strategy,
			layout_strategy = opts.layout_strategy,
			layout_config = {
				width = opts.width,
				height = opts.height,
			},
		})
		:find()
end

---Setup function for the extension
---@param ext_config table: Extension configuration table
---@param telescope_config table: Telescope configuration table
local function setup(ext_config, telescope_config)
	defaults = vim.tbl_deep_extend("force", defaults, ext_config or {})
end

-- Register telescope extension
return telescope.register_extension({
	setup = setup,
	exports = {
		avante = M.avante,
	},
})
