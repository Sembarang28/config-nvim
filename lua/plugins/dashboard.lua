-- Replace the LazyVim splash header on the snacks.nvim dashboard with FORGEVIM.
-- The default keys/actions are inherited from LazyVim; only the header is overridden.
return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███████╗  ██████╗  ██████╗   ██████╗  ███████╗ ██╗   ██╗ ██╗ ███╗   ███╗
██╔════╝ ██╔═══██╗ ██╔══██╗ ██╔════╝  ██╔════╝ ██║   ██║ ██║ ████╗ ████║
█████╗   ██║   ██║ ██████╔╝ ██║  ███╗ █████╗   ██║   ██║ ██║ ██╔████╔██║
██╔══╝   ██║   ██║ ██╔══██╗ ██║   ██║ ██╔══╝   ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
██║      ╚██████╔╝ ██║  ██║ ╚██████╔╝ ███████╗  ╚████╔╝  ██║ ██║ ╚═╝ ██║
╚═╝       ╚═════╝  ╚═╝  ╚═╝  ╚═════╝  ╚══════╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝
]],
        },
      },
    },
  },
}
