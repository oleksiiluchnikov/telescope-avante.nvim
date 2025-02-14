# 🔭 telescope-avante.nvim

A minimalist [Telescope](https://github.com/nvim-telescope/telescope.nvim) picker for switching between [avante.nvim](https://github.com/yetone/avante.nvim) providers with style.

## ✨ Features

- 🔄 Switch between AI providers on the fly
- 🎯 Focused, minimal picker interface
- ✓ Visual indicator for active provider
- 🎨 Adapts to your Telescope theme

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'oleksiiluchnikov/telescope-avante.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'yetone/avante.nvim'
    },
    cmd = 'Telescope avante',
    keys = {
        { '<leader>ap', '<cmd>Telescope avante<CR>', desc = 'Switch AI Provider' }
    }
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'oleksiiluchnikov/telescope-avante.nvim',
    requires = {
        'nvim-telescope/telescope.nvim',
        'yetone/avante.nvim'
    }
}

```

## 🚀 Usage

1. Load the extension:

```lua
require('telescope').load_extension('avante')
```

2. Open the picker:

```lua
:Telescope avante
```

### Recommended Mapping

```lua
vim.keymap.set('n', '<leader>ap',
    require('telescope').extensions.avante.avante,
    { desc = 'Switch AI Provider' }
)
```

## ⚙️ Configuration

The extension uses sensible defaults optimized for a clean, minimal interface. However, you can customize it through Telescope's setup:

```lua
require('telescope').setup({
    extensions = {
        avante = {
            theme = 'dropdown',      -- dropdown, cursor, or ivy
            prompt_title = 'AI Providers',
            previewer = false,
            border = true,
            sorting_strategy = 'ascending',
            layout_strategy = 'center'
        }
    }
})
```

## 🤝 Contributing

Contributions are warmly welcomed! Feel free to:

- [Report bugs](https://github.com/oleksiiluchnikov/telescope-avante.nvim/issues/new?assignees=&labels=bug&template=bug_report.md)
- [Request features](https://github.com/oleksiiluchnikov/telescope-avante.nvim/issues/new?assignees=&labels=enhancement&template=feature_request.md)
- [Submit pull requests](https://github.com/oleksiiluchnikov/telescope-avante.nvim/pulls)

## 📝 License

[MIT](https://choosealicense.com/licenses/mit/)
