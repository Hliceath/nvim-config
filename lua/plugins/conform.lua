return {
	'stevearc/conform.nvim',
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				gdscript = { "gdformat" },
				lua = { "stylua" },
				javascript = { "prettier" },
				-- python = { "isort", "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				typescript = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		})
	end
}
