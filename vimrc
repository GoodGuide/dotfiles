set nocompatible

set shell=/bin/sh

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

syntax on " Enable syntax highlighting
filetype on " Enable filetype detection
filetype indent on " Enable filetype-specific indenting
filetype plugin on " Enable filetype-specific plugins
set ic " Case insensitive search
set hls " Highlight search
set showmatch " Show matching brackets
set expandtab
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set title

set wrap linebreak " soft-wrap
set nolist " list disables linebreak
set cpoptions+=n " use line-numbers column for wrap indicator
let &showbreak="+++ " " wrap indicator

" don't do auto-hard-wrapping, except for comments
set formatoptions+=l " don't break long lines in insert mode
" set formatoptions+=r " insert comment leader after <Enter> in insert mode
set formatoptions+=n " recognize numbered lists and use for autoindent
set formatoptions+=o " insert comment leader on 'o' or 'O'
set formatoptions+=c " auto-wrap comments
set formatoptions+=q " allow formatting comments with 'gq'
set formatoptions+=j " remove comment leader in between joined lines
set formatoptions-=t " don't use textwidth to auto-wrap text
set textwidth=80 " wrap things at 80 chars

" When a bracket is inserted, briefly jump to the matching one.  The
" jump is only done if the match can be seen on the screen.  The time to
" show the match can be set with 'matchtime'.
set showmatch

set backupdir=/tmp/
set directory=/tmp/

set t_Co=256
colorscheme railscasts

" Set a dark background after colorscheme is loaded
set background=dark

" Show characters over 100 lines
if exists('+colorcolumn')
  set colorcolumn=80,100
endif

" highlight current line
set cursorline
autocmd ColorScheme * hi CursorLine ctermbg=234

" Syntax highlighting for all spec files
autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_behaves_like it_should_behave_like before after setup subject its shared_examples_for shared_context let
highlight def link rubyRspec Function

" Setup folding for various file types
au BufNewFile,BufReadPost,BufWritePost *.rb set foldmethod=indent foldignore=""
set foldlevelstart=99

" Format XML docs
au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" List all matches without completing, then each full match
set wildmode=longest,list
" Make tab completion for files/buffers act like bash
set wildmenu
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/bundle/*,vendor/gems/*,*.sassc,*.scssc,tmp/*,log/*,*.png,*.jpg,*.pdf,*.zip,*.gz,public/assets/*,public/uploads/*

" Always save everything
set autowriteall
autocmd FocusLost * silent! wa
autocmd BufLeave * silent! wa

" Set leader to space
let mapleader=" "

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" Save with leader-w
nmap <leader>w :wa<cr>

" Switch between files with leader-leader
nnoremap <leader><leader> <c-^>

" Enable all mouse actions
set mouse=a

" retain visual selection on < or > indent commands
vnoremap > >gv
vnoremap < <gv

" move the current line up and down
"nnoremap <C-J>      :m+<CR>==
"nnoremap <C-K>      :m-2<CR>==

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SMASH
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map smashing j and k to exit insert mode
inoremap jk <esc>
inoremap kj <esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set laststatus=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RELATIVE NUMBER
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Absolute line numbers in insert mode, and relative in normal mode
set number relativenumber
autocmd InsertEnter * :set number norelativenumber
autocmd InsertLeave * :set number relativenumber

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND-T MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:CommandTTagIncludeFilenames=1
let g:CommandTMatchWindowReverse=1

" Open files with <leader>f
map <leader>t :CommandT<cr>
" Open files, limited to the directory of the current file, with <leader>gf
" This requires the %% mapping found below.
map <leader>gt :CommandTFlush<cr>\|:CommandT %%<cr>
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Syntastic {
  let g:syntastic_enable_signs=1
  let g:syntastic_quiet_warnings=0
  let g:syntastic_ruby_checkers=['mri', 'rubocop']
" }

" YankRing {
  " Open Show yank ring buffer
  nnoremap <Leader>y :YRShow<CR>
" }

" Commentary {
  nmap <leader>/ <plug>CommentaryLine<CR>
  vmap <leader>/ <plug>Commentary<CR>
" }

" Fugitve {
  nmap <leader>gb :Gblame<CR>
  nmap <leader>gs :Gstatus<CR>
  nmap <leader>gd :Gdiff<CR>
  nmap <leader>gl :Glog<CR>
  nmap <leader>gc :Gcommit<CR>
  nmap <leader>gp :Git push<CR>
" }

" Rails.vim {
  nnoremap <leader>a :A<CR>  " Go to alternate file
" }

" Ruby {
  " Alternate between do; end and { } blocks in ruby
  let g:blockle_mapping = '<Leader>{'
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
" }

" MatchIt {
  " % to bounce from do to end etc.
  runtime! macros/matchit.vim
" }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HANDY SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" WINDOW SIZES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make the current window big, but leave others context
set winwidth=7
set winwidth=80

" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=7
set winminheight=7
set winheight=999

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimux
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open vimux on the side
let g:VimuxOrientation = "h"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RSPEC SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>a :call RunAllSpecs()<CR>
map <Leader>f :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>

function! RunAllSpecs()
  let l:command = "spring rspec"
  call RunSpecs(l:command)
endfunction

function! RunCurrentSpecFile()
  if InSpecFile()
    let l:command = "spring rspec -fd " . @%
    call SetLastSpecCommand(l:command)
    call RunSpecs(l:command)
  elseif InSpecJSFile()
    let l:command = "spring teaspoon " . @%
    call SetLastSpecCommand(l:command)
    call RunSpecs(l:command)
  endif
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let l:command = "spring rspec -fd " . " -l " . line(".") . " "  . @%
    call SetLastSpecCommand(l:command)
    call RunSpecs(l:command)
  endif
endfunction

function! RunLastSpec()
  if exists("t:last_spec_command")
    call RunSpecs(t:last_spec_command)
  endif
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! InSpecJSFile()
  return match(expand("%"), "_spec.js.coffee$") != -1
endfunction

function! SetLastSpecCommand(command)
  let t:last_spec_command = a:command
endfunction

function! RunSpecs(command)
  " execute ":w\|!clear && echo " . a:command . " && echo && " . a:command
  " call VimuxRunCommand(":w\|!clear && echo " . a:command . " && echo && " . a:command)
  call VimuxRunCommand(a:command)
endfunction

function! s:ChangeHashSyntax(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/:\([a-z0-9_]\+\)\s\+=>/\1:/g'
    call setpos('.', l:save_cursor)
endfunction

command! -range=% ChangeHashSyntax call <SID>ChangeHashSyntax(<line1>,<line2>)

command! -nargs=0 -bar Qargs execute 'args ' . s:QuickfixFilenames()

" Contributed by "ib."
" http://stackoverflow.com/questions/5686206/search-replace-using-quickfix-list-in-vim#comment8286582_5686810
command! -nargs=1 -complete=command -bang Qdo call s:Qdo(<q-bang>, <q-args>)

function! s:Qdo(bang, command)
  if exists('w:quickfix_title')
    let in_quickfix_window = 1
    cclose
  else
    let in_quickfix_window = 0
  endif

  arglocal
  exe 'args '.s:QuickfixFilenames()
  exe 'argdo'.a:bang.' '.a:command
  argglobal

  if in_quickfix_window
    copen
  endif
endfunction

function! s:QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
