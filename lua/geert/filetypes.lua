vim.filetype.add({
  extension = {
    agda = "agda",
    lagda = "agda",
  },
  pattern = {
    [".*%.lagda%.md"] = "agda",
    [".*%.lagda%.org"] = "agda",
    [".*%.lagda%.rst"] = "agda",
    [".*%.lagda%.tex"] = "agda",
    [".*%.lagda%.typ"] = "agda",
  },
})
