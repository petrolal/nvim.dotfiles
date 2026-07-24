local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("yaml", {
  s("cft", {
    t({
      "AWSTemplateFormatVersion: '2010-09-09'",
      "Description: ",
    }),
    i(1, "Minha stack"),
    t({
      "",
      "",
      "Resources:",
      "  ",
    }),
    i(2, "MyResource"),
    t({
      ":",
      "    Type: ",
    }),
    i(3, "AWS::"),
    t({
      "",
      "    Properties:",
      "      ",
    }),
    i(4, "Name: value"),
  }),
})
