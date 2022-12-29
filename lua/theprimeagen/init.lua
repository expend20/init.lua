require("nvim-treesitter.install").prefer_git = true

require("theprimeagen.set")
require("theprimeagen.remap")

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- register new command RealPath and print the real path of the current filename
function RealPath()
    local path = vim.fn.expand('%:p')
    local real_path = vim.fn.fnamemodify(path, ':p')
    -- put the real path_into the clipboard
    vim.fn.setreg('+', real_path)
    print(real_path)
end
vim.cmd('command! -nargs=0 RealPath :lua RealPath()')
vim.keymap.set('n', '<leader>pp', ':RealPath<CR>')

function WriteDefaultClangFormat()
    local sample = [[
Language: Cpp
BasedOnStyle: Microsoft
IndentWidth: 4
UseTab: Never
TabWidth: 4
ColumnLimit: 80
AlignAfterOpenBracket: BlockIndent
]]
    local file = io.open(".clang-format", "w")
    -- check for nil
    if file then
        file:write(sample)
        file:close()
    else
        print("Failed to write .clang-format")
    end
end
vim.cmd('command! -nargs=0 WriteClangFormatDefault :lua WriteDefaultClangFormat()')


