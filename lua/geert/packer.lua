-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use ({
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use {'nvim-tree/nvim-web-devicons'}
    use {'MunifTanjim/nui.nvim'}
    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-tree/nvim-web-devicons',
        }
    }
    use {'nvim-telescope/telescope-file-browser.nvim'}
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('lewis6991/gitsigns.nvim')

    use({'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'})
    use({'neovim/nvim-lspconfig'})
    use({'hrsh7th/nvim-cmp'})
    use({'hrsh7th/cmp-nvim-lsp'})
    use({ 'williamboman/mason.nvim' })
    use({ 'williamboman/mason-lspconfig.nvim' })

    use 'mfussenegger/nvim-dap'
    use {
        'rcarriga/nvim-dap-ui',
        requires = {'mfussenegger/nvim-dap'}
    }
    use 'theHamsta/nvim-dap-virtual-text'
end)
