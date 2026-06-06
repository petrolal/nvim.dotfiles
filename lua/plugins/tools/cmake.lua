return {
  {
    "Civitasv/cmake-tools.nvim",
    event = "VeryLazy",
    opts = {
      cmake_build_directory = "build",
      cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
    },
  },
}
