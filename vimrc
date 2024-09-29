" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

filetype plugin indent on

set autoindent		" always set autoindenting on

set backupdir=~/.vim/backups_nixvim

filetype indent on
filetype plugin on

set tabstop=4 shiftwidth=4 expandtab
set softtabstop=4

" Remove ability to use arrow key. Habit breaking, habit making.
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Latex-Suite stuff
" Highlight searched terms
set hlsearch

" sql stuff
autocmd Filetype sql set tabstop=2 shiftwidth=2 expandtab


" rust stuff
autocmd Filetype rust nnoremap ,ra :CocAction <cr>
autocmd Filetype rust nnoremap ,o :CocCommand rust-analyzer.openDocs <cr>
let g:rust_fold = 1

" .yaml stuff
autocmd Filetype yaml set tabstop=2 shiftwidth=2 expandtab
autocmd Filetype yaml set softtabstop=2

" put cursor on first line of git commit in vim
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

" use tab to switch buffers
nnoremap <Tab> :bnext <cr>
" use tab to switch buffers
nnoremap <S-Tab> :bprevious <cr>

" underline cursorline
set cursorline
hi CursorLine ctermbg=Black cterm=None

" vertical line through cursor
set cursorcolumn
"
" show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
" Show trailing whitespace:
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" set the <leader> to ','
let mapleader = ","

" use ,n to change tabs
nnoremap ,n :w \|:tabNext <cr>

" leader q to close buffer but not the window
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" ,w to save
map ,w :w <cr>
" ,bd to close buffer
map <leader>bd :bd<CR>

" run `!!` command in most recently opened terminal buffer
map <leader>p :w \|:RerunLastThingInLastTerminal <cr>

" run Ctrl-c command in most recently opened terminal buffer
map <leader>c :w \|:CancelInLastTerminal <cr>

" run Ctrl-c command in most recently opened terminal buffer
map <leader>l :w \|:ClearScrollbackInLastTerminal <cr>

" below is what we used before vim terminal
" TODO find a way to user tmux pane instead of vim terminal automatically
" send Ctrl-c to neighboring tmux pane
"map ,c :w \|:! tmux send-keys -t 0:$(tmux display-message -p '\#I').1 C-c <cr><cr>
" run `!!` command in the neighboring tmux pane
map ,t :w \|:! tmux send-keys -t 0:$(tmux display-message -p '\#I').1 C-l C-u "\!\!" Enter Enter <cr><cr>

" show line numbers
set nu

" unlimited undo4eva
set undodir=~/.vim/undodir_nixvim
set undofile

set history=10000

colorscheme gruvbox

"clear the scrollback in the terminal buffer
nmap <c-w><c-l> :set scrollback=1 \| sleep 100m \| set scrollback=10000<cr>
tmap <c-w><c-l> <c-\><c-n><c-w><c-l>i<c-l>

"make Ctrl-w w work as usual when in insert mode in terminal
"much nicer on the firngers than Ctrl-\ Ctrl-n
tnoremap <C-W><C-W> <C-\><C-n><C-W><C-W>

" Spell-check Markdown
autocmd FileType markdown setlocal spell
" enable autocomplet for spelling
autocmd FileType markdown setlocal complete+=kspell

" Spell-check Commit Messages
autocmd FileType gitcommit setlocal spell
" enable autocomplet for spelling
autocmd FileType gitcommit setlocal complete+=kspell

" don't show line number in terminal buffer
autocmd TermOpen * setlocal nonu
