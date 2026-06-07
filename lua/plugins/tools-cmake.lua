return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = "build",
      cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
      },
    },
  },
}
