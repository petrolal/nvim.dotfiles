return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      if not opts.sources then
        return
      end
      for i = #opts.sources, 1, -1 do
        if opts.sources[i].name == "emoji" then
          table.remove(opts.sources, i)
        end
      end
    end,
  },
}

