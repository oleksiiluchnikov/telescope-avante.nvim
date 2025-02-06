local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("This plugin requires nvim-telescope/telescope.nvim")
end

local M = {}

local function avante_providers()
	local providers = {}
	local avante_config = require("plugins.avante").opts
	local vendors = avante_config.vendors

	for name, _ in pairs(vendors) do
		table.insert(providers, name)
	end

	return providers
end

local function switch_avante_provider(prompt_bufnr)
	local selection = action_state.get_selected_entry()
	if not selection then
		return
	end

	local provider_name = selection.value

	-- Update Avante configuration
	local avante_config = require("plugins.avante").opts
	avante_config.provider = provider_name

	-- Notify the user
	vim.notify("Avante provider switched to: " .. provider_name, vim.log.levels.INFO)
end

M.avante_provider_selector = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Avante Provider Selector",
			finder = finders.new_table({
				results = avante_providers(),
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry,
						ordinal = entry,
					}
				end,
			}),
			sorter = sorters.Generic.new({}),
			actions = {
				["select"] = function(prompt_bufnr)
					actions.close(prompt_bufnr)
					switch_avante_provider(prompt_bufnr)
				end,
				[" "] = function(prompt_bufnr)
					actions.close(prompt_bufnr)
				end,
			},
		})
		:find()
end

return M
