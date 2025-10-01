return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "",
      "",
      "",
      "",
      [[                                                                    ]],
      [[88                                                                  ]],
      [[88                                                                  ]],
      [[88                                                                  ]],
      [[88,dPPYba,  ,adPPYba, 8b,dPPYba,   ,adPPYba, 8b       d8  ,adPPYba,  ]],
      [[88P'    "8a I8[    "" 88P'   `"8a a8P_____88 `8b     d8' a8P_____88  ]],
      [[88       d8  `"Y8ba,  88       88 8PP"""""""  `8b   d8'  8PP"""""""  ]],
      [[88b,   ,a8" aa    ]8I 88       88 "8b,   ,aa   `8b,d8'   "8b,   ,aa  ]],
      [[8Y"Ybbd8"'  `"YbbdP"' 88       88  `"Ybbd8"'     Y88'     `"Ybbd8"'  ]],
      [[                                                  d8'                 ]],
      [[                                                 d8'                  ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
      dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("q", "  Quit", ":qa <CR>"),
    }

    alpha.setup(dashboard.opts)
  end,
}