" Url: HTTP://VIM.WIkia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.

"------------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on


"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu
set wildmode=longest,list
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.swo,*.tmp

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
set incsearch

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR>:redraw!<CR>

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
"set ignorecase
"set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
"set t_vb=

" Enable use of the mouse for all modes
"set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
"set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
"set pastetoggle=<F11>


"------------------------------------------------------------
" Split options

" Open splits below and to the right instead of up and left
set splitbelow
set splitright

"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
set shiftwidth=2
set softtabstop=2
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
set tabstop=4

" Disable automatic text wrappping.
" Hot take: Automated text wrapping sucks. Use a formatter on save instead.
set textwidth=0

" Bind ctrl-j and ctrl-k for quicker autocomplete in insert mode.
if has('nvim')
  " In nvim, use CoC based autocomplete.
  inoremap <expr> <C-J> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
  inoremap <expr> <C-K> coc#pum#visible() ? coc#pum#prev(1) : coc#refresh()
else
  inoremap <C-J> <C-N>
  inoremap <C-K> <C-P>
endif

" Bind ctrl-j and ctrl-k to scroll in normal mode.
nmap <C-J> <C-E>
nmap <C-K> <C-Y>

" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Moving back and forth between lines of same or lower indentation.
" Useful for navigation in Python sources.
nnoremap <silent> [l :<C-u>call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]l :<C-u>call NextIndent(0, 1, 0, 1)<CR>
nnoremap <silent> [L :<C-u>call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> ]L :<C-u>call NextIndent(0, 1, 1, 1)<CR>
vnoremap <silent> [l <Esc>:<C-u>call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:<C-u>call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> [L <Esc>:<C-u>call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:<C-u>call NextIndent(0, 1, 1, 1)<CR>m'gv''
onoremap <silent> [l :<C-u>call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]l :<C-u>call NextIndent(0, 1, 0, 1)<CR>
onoremap <silent> [L :<C-u>call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> ]L :<C-u>call NextIndent(1, 1, 1, 1)<CR>

"------------------------------------------------------------
" Mappings
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Add the ability to insert a single charecter by pressing 's' or 'S'
nnoremap S :<C-u>exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap s :<C-u>exec "normal a".nr2char(getchar())."\e"<CR>

" Map // in visual mode to search under selection
vnoremap // y/<C-R>"<CR>

" Navigate tabs with J and K (like vimium)
nnoremap J gT
nnoremap K gt

" Leader bindings for quick execution
" -----------------------------------

" Bind Leader ee to execute the current file
nnoremap <Leader>ee :<C-u>!./%<CR>

" Bind Leader eb to execute the buffer in bash
nnoremap <Leader>eb :<C-u>w !bash<CR>
xnoremap <Leader>eb :w !bash<CR>

" Bind Leader ep to execute the buffer in Python
nnoremap <Leader>ep :<C-u>w !python<CR>
xnoremap <Leader>ep :w !python<CR>

" Bind Leader en to execute the buffer in Node
nnoremap <Leader>en :<C-u>w !node<CR>
xnoremap <Leader>en :w !node<CR>

" Bind Leader eq to execute the buffer in BigQuery SQL
nnoremap <Leader>eq :<C-u>w !bq query<CR>
xnoremap <Leader>eq :w !bq query<CR>

" Bind Leader keys for tab commands
" NOTE: Intentional trailing space
nnoremap <Leader>o :<C-u>tabe 
nnoremap <Leader>te :<C-u>tabe 
nnoremap <Leader>tc :<C-u>tabc<CR>
nnoremap <Leader>td :<C-u>tabdo 
nnoremap <Leader>tq :<C-u>tabc<CR>
nnoremap <Leader>tO :<C-u>tabo<CR>
nnoremap <Leader>tm :<C-u>tabm 
nnoremap <Leader>tj :<C-u>tabm -1<CR>
nnoremap <Leader>tk :<C-u>tabm +1<CR>

" Bind Leader s save
nnoremap <Leader>s :<C-u>w<CR>

" Bind Leader S save all windows
nnoremap <Leader>S :<C-u>wa<CR>

" Bind Leader q close the current window
nnoremap <Leader>q :<C-u>q<CR>

" Bind Leader Q close all windows
nnoremap <Leader>Q :<C-u>qa<CR>

" Bind Leader z to save and close the current window
nnoremap <Leader>z :<C-u>wq<CR>
"
" Bind Leader Z to save and close all windows
nnoremap <Leader>Z :<C-u>wqa<CR>

" Bind Leader b to issue common build commands.
autocmd FileType go nnoremap <Leader>b :<C-u>w<CR>:GoBuild<CR>
autocmd FileType rust nnoremap <Leader>b :<C-u>w<CR>:Cargo build<CR>

" Bind Leader m to make
nnoremap <Leader>m :<C-u>w<CR>:make<CR>

" Bind Leader < to sort a paragraph (imports)
nnoremap <Leader>< vip:<C-u>sort<CR>
xnoremap <Leader>< :sort<CR>

" Bind Leader > to reverse sort a paragraph (imports)
nnoremap <Leader>> vip:<C-u>sort!<CR>
xnoremap <Leader>> :sort!<CR>

"------------------------------------------------------------
" Line wrapping options

function EnableWrapNavigation()
  nnoremap <buffer> <Up> gk
  nnoremap <buffer> <Down> gj
  inoremap <buffer> <Up> <C-O>gk
  inoremap <buffer> <Down> <C-O>gj
  vnoremap <buffer> <Up> gk
  vnoremap <buffer> <Down> gj
  noremap <buffer> k gk
  noremap <buffer> j gj
  noremap <buffer> 0 g0
  noremap <buffer> ^ g^
  noremap <buffer> $ g$
endfunction

function DisableWrapNavigation()
  nunmap <buffer> <Up>
  nunmap <buffer> <Down>
  iunmap <buffer> <Up>
  iunmap <buffer> <Down>
  vunmap <buffer> <Up>
  vunmap <buffer> <Down>
  nunmap <buffer> k
  nunmap <buffer> j
  nunmap <buffer> 0
  nunmap <buffer> ^
  nunmap <buffer> $
endfunction

" Bind Leader .we and .wd to enable and disable line wrap navigation.
nnoremap <Leader>.we :<C-u>call EnableWrapNavigation()<CR>
nnoremap <Leader>.wd :<C-u>call DisableWrapNavigation()<CR>

" Bind Leader .ww to toggle line wrapping.
nnoremap <Leader>.ww :<C-u>set wrap!<CR>

" Bind Leader .p to toggle paste mode
nnoremap <Leader>.p :<C-u>set paste!<CR>

" Bind Leader .n to toggle line numbers
nnoremap <Leader>.n :<C-u>set number!<CR>

" Bind Leader .b to toggle scroll bind
nnoremap <Leader>.b :<C-u>set scrollbind!<CR>

" Bind Leader .s to toggle spell-check
set spelllang=en_us
nnoremap <Leader>.s :<C-u>set spell!<CR>

" Bind Leader .x to toggle syntax highlighting
nnoremap <Leader>.x :<C-u>if exists("g:syntax_on") <BAR> syntax off <BAR> else <BAR> syntax enable <BAR> endif<CR>

"------------------------------------------------------------
" Rust options
let g:rustfmt_autosave = 1

"------------------------------------------------------------
" Diff leader commands

" TODO(victor) Make this a toggle with dd (or just d) as diff this for a window and dD for all.
nnoremap <Leader>dD :<C-u>windo diffthis<CR>
nnoremap <Leader>dd :<C-u>diffthis<CR>
nnoremap <Leader>du :<C-u>windo diffupdate<CR>
nnoremap <Leader>dO :<C-u>diffoff!<CR>
nnoremap <Leader>do :<C-u>diffoff<CR>

"------------------------------------------------------------
" Git Fugitive leader commands

" Add the commit and branch information to the status line
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" Create a quickfix window with the files that have changed in a diff.
" DEPRECATED
command -nargs=? -bar GReview call setqflist(map(systemlist("git diff --pretty='' --name-only <args> --"), '{"filename": v:val, "lnum": 1}'))|cwindow|redraw!

" Useful bindings for Git and Github operations.
" Set the diffbase variable with soemthing like `let g:diffbase = "deadbeef"`
let g:diffbase = "HEAD"
nnoremap <Leader>gd :<C-u>Gdiff! origin/HEAD...<CR>
nnoremap <Leader>gD :<C-u>exec "Gdiff!" g:diffbase . "..."<CR>
nnoremap <Leader>gs :<C-u>Git<CR>
" Add the current buffer to the index (i.e. git add). Save the buffer first.
nnoremap <Leader>gw :<C-u>w<CR>:Gwrite<CR>
" Set the current buffer to the value in the index (i.e. git checkout).
nnoremap <Leader>gr :<C-u>Gread<CR>
nnoremap <Leader>gc :<C-u>Git commit<CR>
nnoremap <Leader>gp :<C-u>Git push<CR>
nnoremap <Leader>gB :<C-u>Git blame<CR>
nnoremap <Leader>gl :<C-u>Git log<CR>
nnoremap <Leader>gb :<C-u>GBrowse!<CR>
xnoremap <Leader>gb :GBrowse!<CR>
nnoremap <Leader>gr :<C-u>"Git" "difftool" --name-only origin/HEAD...<CR>
nnoremap <Leader>gR :<C-u>exec "Git" "difftool" "--name-only" g:diffbase . "..."<CR>

"------------------------------------------------------------
" The Silver Searcher (and grep) and Ack.vim

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --vimgrep
  let g:ackprg = 'ag --vimgrep'
endif

" bind = to grep word under cursor
nnoremap = yiw:<C-u>copen<CR>:Ack! '\b<C-R>0\b'

" bind Leader f to open ack and populate it with selected text if applicable.
" TODO: Fix and consolidate search bindings.
nnoremap <Leader>f y:<C-u>Ack! 
xnoremap <Leader>f y:Ack! '<C-R>=escape(@",'/\')<CR>'

" bind Leader x to close the quickfix window
nnoremap <Leader>x :<C-u>cclose<CR>

" bind space in quickfix window to open in new tab
let g:ack_mappings = { "<space>": "<C-W><CR><C-W>T" }

"------------------------------------------------------------
" fzf

" If you have cloned fzf on ~/.fzf directory, load the
" vimscript it contains to enable it as a plugin.
set rtp+=~/.fzf

" Additionally using fzf.vim
" https://github.com/junegunn/fzf.vim
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <c-_> :<C-u>Buffers<CR>
nnoremap <c-g> :<C-u>GFiles?<CR>

" - Preview window on the right with 50% width
" - Preview window hidden by default.
" - CTRL-p will toggle preview window.
let g:fzf_vim = {}
let g:fzf_vim.buffers_jump = 1
let g:fzf_vim.preview_window = ['hidden,right,50%', 'ctrl-p']

" Build a quickfix list from the selected entries.
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',  
  \ 'space': 'tab drop',
  \ }

" Use ag as the default search command for fzf, respecting .gitignore.
let $FZF_DEFAULT_COMMAND = 'ag --hidden -g ""'

"------------------------------------------------------------
" Easymotion

let g:EasyMotion_do_mapping = 0

" Jump to anywhere you want with minimal keystrokes, with just one key
" binding.
nmap t <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Turn on async ctag updates
let g:easytags_async = 1

"------------------------------------------------------------
" vim-go
" https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt

let g:go_doc_keywordprg_enabled = 0

"------------------------------------------------------------
" vim-signiture

" Fix margin background color.
" https://github.com/kshenoy/vim-signature/issues/116#issuecomment-231510680
hi SignColumn guibg=NONE
hi SignColumn ctermbg=NONE
hi SignatureMarkText ctermbg=NONE

"------------------------------------------------------------
" bookmarks (github.com/MattesGroeger/vim-bookmarks)

let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

"-----------------------------------------------------------
" vim-polyglot (github.com/sheerun/vim-polyglot)

" Disable vim-polyglots CSV syntax rules.
let g:polyglot_disabled = ['csv']

"-----------------------------------------------------------
" Themes

" In diff mode, the default colorscheme can make words hard to read due to low contrast between the
" diff highlight and the text color. Use a custom theme to make this a little better.
" Installed themes:
" * molokai    (https://github.com/tomasr/molokai)
" * jellybeans (https://github.com/nanotech/jellybeans.vim)
" * papercolor (https://github.com/NLKNguyen/papercolor-theme)

set termguicolors
set background=dark

if &diff
  colorscheme jellybeans
else
  colorscheme papercolor
endif

" Override for jellybeans to use the terminal background instead of its own color.
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none' },
\}

"------------------------------------------------------------
" Plugin

" Turn on pathogen
execute pathogen#infect()
