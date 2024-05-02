return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						-- move to prev result
						["<C-k>"] = actions.move_selection_previous,
						-- move to next result
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			file_ignore_patterns = { "node%_modules/.*" },
		})

		telescope.load_extension("fzf")

		local project_root = function()
			local root_names = { ".git", "go.mod", "Makefile" }

			-- get path to current buffer
			local fname = vim.api.nvim_buf_get_name(0)
			if fname == "" then
				return
			end

			-- get current working directory
			local cwd = vim.fs.dirname(fname)

			-- searching upward for root directory
			local root_file = vim.fs.find(root_names, { path = cwd, upward = true })[1]
			-- if root_names not found, return cwd
			if root_file == nil then
				return cwd
			end

			return vim.fs.dirname(root_file)
		end

		local find_in_project = function()
			builtin.find_files({ cwd = project_root() })
		end

		-- set keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", find_in_project, { desc = "Find files in current project" })
		keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find files in open buffers" })
		keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", builtin.lsp_document_symbols, { desc = "Find string in LSP symbols" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
