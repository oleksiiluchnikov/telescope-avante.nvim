local has_telescope = pcall(require, "telescope")
if not has_telescope then
	error("telescope-avante.nvim requires telescope.nvim - https://github.com/nvim-telescope/telescope.nvim")
end

return require("telescope").register_extension({
	exports = {
		avante = require("telescope-avante").avante,
	},
})
