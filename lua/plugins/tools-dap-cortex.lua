return {
  {
    "jedrzejboczar/nvim-dap-cortex-debug",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      debug_server = "openocd",
    },
    config = function(_, opts)
      require("dap-cortex-debug").setup(opts)

      -- Configuration for ESP32 and ARM
      local dap = require("dap")

      dap.configurations.c = {
        {
          type = "cortex-debug",
          request = "launch",
          name = "ESP32 (OpenOCD)",
          servertype = "openocd",
          interface = "jtag",
          toolchainPrefix = "xtensa-esp32-elf",
          -- Set to true if you have the SVD file
          -- svdFile = "${workspaceFolder}/esp32.svd",
        },
        {
          type = "cortex-debug",
          request = "launch",
          name = "ARM Cortex (OpenOCD)",
          servertype = "openocd",
          -- Adjust these based on your specific chip
          -- svdFile = "${workspaceFolder}/STM32F407.svd",
        },
      }
      dap.configurations.cpp = dap.configurations.c
    end,
  },
}
