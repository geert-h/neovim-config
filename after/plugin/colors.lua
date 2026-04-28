
function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
	vim.api.nvim_set_hl(0, "Visual", { bg = "#5f5a7a", fg = "#f2e9e1" })
	vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#5f5a7a", fg = "#f2e9e1" })
end

ColorMyPencils()
