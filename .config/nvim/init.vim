set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set updatetime=300

let g:LanguageClient_serverCommands = { 'rust': ['rust-analyzer'] }

" Set the set of extensions that should be installed.
let g:coc_global_extensions = ['coc-json', 'coc-rust-analyzer', 'coc-markdownlint']

" Tone down the inlay hint text brightness a bit to make it easier to distinguish from code.
:hi CocInlayHint guifg=DarkGrey

" With CoC, bind ]g and [g to next and prev diagnostics message.
nnoremap [g <Plug>(coc-diagnostic-prev)
nnoremap ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

inoremap <silent> <C-S> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<CR>

" bind Leader c CoC command0.s and actions
nnoremap <Leader>cx :<C-u>CocFzfList<CR>
nnoremap <Leader>cc :<C-u>CocFzfList commands<CR>
nnoremap <Leader>cd :<C-u>CocFzfList diagnostics<CR>
nnoremap <Leader>cs :<C-u>CocFzfList symbols<CR>
nnoremap <Leader>co :<C-u>CocFzfList outline<CR>
nnoremap <Leader>ca :<C-u>CocFzfList actions<CR>
xnoremap <Leader>ca :CocFzfList actions<CR>

nnoremap <Leader>a <Plug>(coc-fix-current)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" TODO: Add something for :call CocAction('showSignatureHelp')

" Disable mouse support.
set mouse=
