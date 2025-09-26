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
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
			},
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = { "%.git/.*", "node_modules/.*", "%.cache/.*" },
				},
			},
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

		local find_file_in_project = function()
			builtin.find_files({ cwd = project_root() })
		end

		local find_text_in_project = function()
			builtin.live_grep({ cwd = project_root() })
		end

		local find_text_in_open_buffers = function()
			builtin.live_grep({ grep_open_files = true })
		end

		local find_diagnostics_in_current_buffer = function()
			builtin.diagnostics({ bufnr = 0 })
		end

		-- set keymaps
		local keymap = vim.keymap

		-- find files
		keymap.set("n", "<leader>ff", find_file_in_project, { desc = "Find files in project" })
		keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find files in open buffers" })
		-- find text
		keymap.set("n", "<leader>fg", find_text_in_open_buffers, { desc = "Find text in open buffers" })
		keymap.set("n", "<leader>fG", find_text_in_project, { desc = "Find text in project" })
		-- find lsp symbols
		keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find LSP symbols in current buffer" })
		keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "Find LSP symbols in workspace" })
		-- find diagnostics
		local opts = { desc = "Find diagnostics in current buffer" }
		keymap.set("n", "<leader>fd", find_diagnostics_in_current_buffer, opts)
		keymap.set("n", "<leader>fD", builtin.diagnostics, { desc = "Find diagnostics in project" })
		-- find TODOs
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
