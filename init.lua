require("config.options")
require("config.keymaps")

local function run_build(name, cmd, cwd)
	local result = vim.system(cmd, { cwd = cwd }):wait()
	if result.code ~= 0 then
		local stderr = result.stderr or ""
		local stdout = result.stdout or ""
		local output = stderr ~= "" and stderr or stdout
		if output == "" then
			output = "No output from build command."
		end
		vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
	end
end

-- runs after a plugin is installed or updated and runs the appropriate build
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end

		if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
			run_build(name, { "make" }, ev.data.path)
			return
		end

		if name == "LuaSnip" then
			if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
				run_build(name, { "make", "install_jsregexp" }, ev.data.path)
			end
			return
		end

		if name == "nvim-treesitter" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
			return
		end
	end,
})

local gh = function(x)
	return "https://github.com/" .. x
end
local cb = function(x)
	return "https://codeberg.org/" .. x
end

local telescope_plugins = {
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-ui-select.nvim"),
}
if vim.fn.executable("make") == 1 then
	table.insert(telescope_plugins, gh("nvim-telescope/telescope-fzf-native.nvim"))
end

local mason = {
	gh("neovim/nvim-lspconfig"),
	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
}

local dap = {
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/leoluz/nvim-dap-go",
}

local neotree = {
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("*") },
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
}
if vim.g.have_nerd_font then
	table.insert(neotree, "https://github.com/nvim-tree/nvim-web-devicons")
end

vim.pack.add({
	gh("stevearc/conform.nvim"), -- formatting
	gh("j-hui/fidget.nvim"), -- status update for LSP
	gh("lewis6991/gitsigns.nvim"), -- adds git related signs
	gh("NMAC427/guess-indent.nvim"), -- detects and sets automatically the indentation
	gh("lukas-reineke/indent-blankline.nvim"), -- add indentation guides
	gh("nvim-mini/mini.nvim"), -- various independent plugins/modules
	gh("windwp/nvim-autopairs"), -- autopairs
	gh("mfussenegger/nvim-lint"), -- lint
	gh("nvim-tree/nvim-web-devicons"), -- adds pretty icons
	gh("folke/todo-comments.nvim"), -- highlight todo
	gh("folke/tokyonight.nvim"), -- colorscheme
	gh("folke/which-key.nvim"), -- show pending keybinds
	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") }, -- snippet engine
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") }, -- autocomplete engine
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" }, -- highlight
})
vim.pack.add(mason) -- LSPs and related tools
vim.pack.add(dap) -- debug code
vim.pack.add(neotree) -- show file system
vim.pack.add(telescope_plugins) -- fuzzy finder

require("plugins.tokyonight")
vim.cmd.colorscheme("tokyonight-moon")

require("plugins.autopairs")
require("plugins.blink")
require("plugins.conform")
require("plugins.debug")
require("plugins.gitsigns")
require("plugins.guess-indent")
require("plugins.indent-blankline")
require("plugins.lint")
require("plugins.mason")
require("plugins.mini")
require("plugins.neo-tree")
require("plugins.luasnip")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.web-devicons")
require("plugins.which-key")
