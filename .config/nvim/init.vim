set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set updatetime=300

let g:LanguageClient_serverCommands = { 'rust': ['rust-analyzer'] }

" Set the set of extensions that should be installed.
let g:coc_global_extensions = ['coc-json', 'coc-rust-analyzer']

" With CoC, bind ]g and [g to next and prev diagnostics message.
nnoremap [g <Plug>(coc-diagnostic-prev)
nnoremap ]g <Plug>(coc-diagnostic-next)

" bind Leader c CoC commands and actions
nnoremap <Leader>cx :<C-u>CocFzfList<CR>
nnoremap <Leader>cc :<C-u>CocFzfList commands<CR>
nnoremap <Leader>cd :<C-u>CocFzfList diagnostics<CR>

" Disable mouse support.
set mouse=
