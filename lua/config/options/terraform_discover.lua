-- Added terraform auto discover
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
    nomad = "hcl",
  },
  filename = {
    [".terraformrc"] = "hcl",
    ["terraform.rc"] = "hcl",
  },
})
