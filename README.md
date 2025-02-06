# telescope-avante.nvim

A Telescope extension for [avante.nvim](https://github.com/olivercederborg/telescope-media-files.nvim) that allows you to switch avante providers.

## Features

- Switch avante providers using Telescope.
- Elegant and mini picker UI.

## Installation

Install the extension with your package manager of choice:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'oleksiiluchnikov/telescope-avante.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'yetone/avante.nvim' }
}
```

## Usage

```lua
:Telescope avante
```

You can also add a key mapping:

```lua
vim.keymap.set('n', '<leader>ap',
    ':Telescope avante<CR>',
    { desc = 'Switch Avante Provider' }
)
```

## Configuration

No configuration options are available.

## Dependencies

- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [avante.nvim](https://github.com/yetone/avante.nvim)

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

[MIT](LICENSE)
