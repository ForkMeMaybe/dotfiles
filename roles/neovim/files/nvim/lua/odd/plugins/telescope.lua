return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        preview = {
          treesitter = false,
        },
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.9,
          height = 0.9,
          horizontal = {
            preview_width = 0.5,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.9,
            horizontal = {
              preview_width = 0.5,
            },
          },
        },
        live_grep = {
          theme = "dropdown",
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.9,
            horizontal = {
              preview_width = 0.5,
            },
          },
        },
        keymaps = {
          theme = "dropdown",
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.9,
            horizontal = {
              preview_width = 0.5,
            },
          },
        },
        commands = {
          theme = "dropdown",
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.9,
            horizontal = {
              preview_width = 0.5,
            },
          },
        },
        help_tags = {
          theme = "dropdown",
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.9,
            horizontal = {
              preview_width = 0.5,
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    telescope.load_extension("fzf")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find Git files" })
    vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>pk", builtin.keymaps, { desc = "Search keymaps" })
    vim.keymap.set("n", "<leader>pc", builtin.commands, { desc = "Search commands" })
    vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Search help tags" })
  end,
}