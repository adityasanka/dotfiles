return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({
			-- enable treesitter
			check_ts = true,
			ts_config = {
				-- don't add pairs in lua string treesitter nodes
				lua = { "string" },
				-- don't add pairs in javascript template_string treesitter nodes
				javascript = { "template_string" },
				-- don't check treesitter on java
				java = false,
			},
		})
	end,
}
