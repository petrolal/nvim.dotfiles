return {version=12,pkgs={{source="lazy",spec=function()
return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {},
}

end,name="kulala.nvim",file="lazy.lua",dir="/home/petrolal/.local/share/nvim/lazy/kulala.nvim",},{source="lazy",spec=function()
return {
  -- nui.nvim can be lazy loaded
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "folke/noice.nvim",
  },
}

end,name="noice.nvim",file="lazy.lua",dir="/home/petrolal/.local/share/nvim/lazy/noice.nvim",},{source="rockspec",spec={"nvim-dap-python",build=false,specs={{"mfussenegger/nvim-dap",},},},name="nvim-dap-python",file="nvim-dap-python-scm-1.rockspec",dir="/home/petrolal/.local/share/nvim/lazy/nvim-dap-python",},{source="lazy",spec={"nvim-lua/plenary.nvim",lazy=true,},name="plenary.nvim",file="community",dir="/home/petrolal/.local/share/nvim/lazy/plenary.nvim",},{source="rockspec",spec={"telescope.nvim",build=false,specs={{"nvim-lua/plenary.nvim",lazy=true,},},},name="telescope.nvim",file="telescope.nvim-scm-1.rockspec",dir="/home/petrolal/.local/share/nvim/lazy/telescope.nvim",},},}