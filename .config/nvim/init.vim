set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set updatetime=300

let g:LanguageClient_serverCommands = { 'rust': ['rust-analyzer'] }

" Set the set of extensions that should be installed.
let g:coc_global_extensions = ['coc-json', 'coc-rust-analyzer']

" With CoC, bind ]g and [g to next and prev diagnostics message.
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

" Map C-[ to pull up a fuzzy finder for Coc commands.
nnoremap <silent> <C-m> :CocList commands<CR>

" Disable mouse support.
set mouse=
