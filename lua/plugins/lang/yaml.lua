return {
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- Configure YAML LSP for CloudFormation
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              customTags = {
                -- CloudFormation intrinsic functions
                "!Base64 scalar",
                "!Cidr scalar",
                "!And sequence",
                "!Equals sequence",
                "!If sequence",
                "!Not sequence",
                "!Or sequence",
                "!Condition scalar",
                "!FindInMap sequence",
                "!GetAtt scalar",
                "!GetAtt sequence",
                "!GetAZs scalar",
                "!ImportValue scalar",
                "!Join sequence",
                "!Select sequence",
                "!Split sequence",
                "!Sub scalar",
                "!Sub sequence",
                "!Transform mapping",
                "!Ref scalar",
              },
              schemas = {
                -- CloudFormation schema
                ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = "cloudformation/*.{yml,yaml}",
              },
              format = {
                enable = true,
              },
              validate = true,
              hover = true,
              completion = true,
            },
          },
        },
      },
    },
  },
}
