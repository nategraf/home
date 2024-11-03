set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set updatetime=300

" Set the set of extensions that should be installed.
let g:coc_global_extensions = ['coc-json', 'coc-rust-analyzer', 'coc-markdownlint']

" Feed more memory to MolochJS in hopes of appeasing it.
" TIP: Add --cpu-prof and --heap-prof to get profiles.
let g:coc_node_args = ['--max-old-space-size=8192']

" Tone down the inlay hint text brightness a bit to make it easier to distinguish from code.
:hi CocInlayHint guifg=DarkGrey

" With CoC, bind ]g and [g to next and prev diagnostics message.
nnoremap [d <Plug>(coc-diagnostic-prev)
nnoremap ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gl :<C-u>CocFzfListResume<CR>

"https://github.com/neoclide/coc.nvim/issues/318
"nnoremap <silent> gd <C-u>:call CocAction('jumpDefinition', 'tab drop')<CR>
"nnoremap <silent> gy <C-u>:call CocAction('jumpTypeDefinition', 'tab drop')<CR>
"nnoremap <silent> gi <C-u>:call CocAction('jumpImplementation', 'tab drop')<CR>
"nnoremap <silent> gr <C-u>:call CocAction('jumpReferences', 'tab drop')<CR>

inoremap <C-s> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<CR>

" bind Leader c CoC command0.s and actions
nnoremap <Leader>cx :<C-u>CocFzfList<CR>
nnoremap <Leader>cc :<C-u>CocFzfList commands<CR>
nnoremap <Leader>cd :<C-u>CocFzfList diagnostics<CR>
nnoremap <Leader>cs :<C-u>CocFzfList symbols<CR>
nnoremap <Leader>co :<C-u>CocFzfList outline<CR>
nnoremap <Leader>ca :<C-u>CocFzfList actions<CR>
xnoremap <Leader>ca :CocFzfList actions<CR>

" Only get suggestions when requested.
let g:copilot_enabled=v:false

inoremap <silent><script><expr> <C-l> copilot#Accept("\<CR>")
inoremap <C-h> <Cmd>call copilot#Suggest()<CR>
let g:copilot_no_tab_map = v:true
let g:copilot_no_maps = v:true

" Disable mouse support.
set mouse=
