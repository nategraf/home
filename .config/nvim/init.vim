set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set updatetime=300

let g:LanguageClient_serverCommands = { 'rust': ['rust-analyzer'] }

" Set the set of extensions that should be installed.
let g:coc_global_extensions = ['coc-json', 'coc-rust-analyzer']

" With CoC, bind ]g and [g to next and prev diagnostics message.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Disable mouse support.
set mouse=
