require("config.options")
require("config.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    require("plugins.alpha"),         -- Greeter
    require("plugins.autopairs"),     -- Autoclose parenthesis, brackets, etc.
    require("plugins.blink"),         -- Autocompletion
    require("plugins.gitsigns"),      -- Git decorations
    require("plugins.indent-blankline"), -- Show indent lines
    require("plugins.lspconfig"),     -- LSP
    require("plugins.lualine"),       -- Status bar
    require("plugins.neotree"),       -- File tree
    require("plugins.none-ls"),       -- Autoformat on save
    require("plugins.rose-pine"),     -- Color theme
    require("plugins.telescope"),     -- Search
    require("plugins.treesitter"),    -- Color code syntax
    require("plugins.typescript-tools"), -- LSP for TypeScript
    require("plugins.which-key"),     -- Show keybinds description
})
