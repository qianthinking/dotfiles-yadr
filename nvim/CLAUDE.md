# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim Configuration Architecture

This is a modern Neovim configuration using **lazy.nvim** as the plugin manager. The configuration supports both standalone Neovim and VSCode integration through dual configuration paths.

### Key Architectural Components

**Plugin Management**: Uses lazy.nvim with automatic plugin loading via `spec = { import = "plugins" }` pattern. All plugin configurations are automatically discovered and loaded from the plugins directory.

**Dual Environment Support**: 
- Standard Neovim: Full configuration with LSP, file explorer, statusline
- VSCode integration: Stripped-down config in `myvscode/` with essential movement plugins

**Modular Organization**:
- `lua/plugins/`: Plugin configurations organized by category (editor/, ui/)
- `lua/mappings/`: Keybindings organized by functionality (editing, search, window, toggle)
- `lua/config/`: Core settings and lazy.nvim setup
- `legacy/`: VimScript files for backwards compatibility

### Plugin Categories and Key Components

**LSP Stack**: nvim-lspconfig + Mason for automatic language server management, nvim-cmp for completion with multiple sources (LSP, buffer, path, cmdline).

**File Management**: nvim-tree as primary file explorer, Telescope for fuzzy finding with live grep and LSP integration.

**Editor Enhancements**: Treesitter for syntax highlighting, flash/hop for quick navigation, multiple AI coding assistants (Copilot, Avante, ChatGPT).

**UI Components**: Lualine statusline with enhanced diagnostics, tabby for tab management, various color themes.

### Keybinding System

**Leader Key**: Comma (`,`) used for both `mapleader` and `maplocalleader`

**Prefix Organization**:
- `<leader>f*`: File and search operations (Telescope integration)
- `<leader>c*`: Code actions and clipboard operations  
- `<leader>d*`, `<leader>e*`: Diagnostics and error navigation
- `t*`: Feature toggles (nvim-tree, indentLine, etc.)

**Smart Buffer Management**: Custom `CloseWindowOrKillBuffer` function in `lua/mappings/window.lua` handles complex window/buffer scenarios.

### VSCode Integration Details

When `vim.g.vscode` is detected, the configuration loads `myvscode/` modules instead of full Neovim setup. VSCode-specific keybindings use `VSCodeNotify` to integrate with VSCode commands while maintaining familiar Neovim keybindings.

### Legacy VimScript Integration

The configuration sources VimScript files from `legacy/` directory:
- `mapping.vim`: Classic Vim text object operations and surround functionality
- `next-textobject.vim`: Advanced text object motions (`an`, `in`, `al`, `il`)

These provide enhanced text manipulation capabilities that complement the Lua-based configuration.

## Development Commands

**Plugin Management**:
- `:Lazy` - Open lazy.nvim plugin manager interface
- `:Lazy sync` - Update all plugins
- `:Lazy clean` - Remove unused plugins

**LSP Operations**:
- `:Mason` - Manage language servers
- `:LspInfo` - Show LSP client information
- `:LspRestart` - Restart LSP clients

**File Operations**:
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep search
- `<leader>fb` - Browse buffers
- `tt` - Toggle nvim-tree file explorer

**Configuration Reload**:
- `:source %` - Reload current Lua file
- `:lua package.loaded['module_name'] = nil` - Clear module cache before reloading

## Important Configuration Files

**Core Setup**: `init.lua` (entry point), `lua/config/lazy.lua` (plugin manager setup), `lua/config/settings.lua` (Vim options)

**Plugin Definitions**: `lua/plugins/init.lua` (main plugin loader), individual plugin configs in `lua/plugins/editor/` and `lua/plugins/ui/`

**Keybinding Definitions**: Files in `lua/mappings/` organized by functionality

**VSCode Integration**: All files in `myvscode/` directory for VSCode-specific configuration