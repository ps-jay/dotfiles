"       from RHEL6
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

"       good defaults from RHEL6
set nocompatible
set bs=indent,eol,start
set history=1000
"set viminfo='20,\"50
set ruler

"       ignore case when searching (unless case is given in search string)
set ignorecase smartcase

"       smart auto indent
set smartindent

"       inform user about anything that involved more than one line
set report=2

"       indent code 4 spaces
set shiftwidth=4

"       tabs = spaces
set expandtab

"       show matching brackets for 2/10s
set showmatch matchtime=2

"       magic patterns
set magic

"       don't highlight search
set nohlsearch

"	make backspace work like most other apps
set backspace=2

"       coloured columns
set colorcolumn=80,120
highlight ColorColumn ctermbg=255

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

"       do detect filetypes & enable syntax
filetype on
filetype plugin on
if &t_Co > 2 || has("gui_running")
    syntax enable
endif

"       command mode tab completion work like tcsh autolist=ambiguous
set wildmode=longest,list

"       disable auto-insertion of comment markers
autocmd FileType * setlocal formatoptions-=r formatoptions-=o

"       key mappings for tabs
map  th             :tabfirst<CR>
map  tj             :tabnext<CR>
map  tk             :tabprev<CR>
map  tl             :tablast<CR>
map  tt             :tabedit<Space>

"       key mappings for pasting
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"       tab-separated files: don't expand tabs
autocmd BufNewFile,BufRead *.tsv set noexpandtab

"       gitcommits: goto line 0
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

"       I like modelines ... sec risk tho ...
set modeline
set modelines=2

"	fonts for gvim
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h10:cANSI
  endif
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"
