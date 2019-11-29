" ####################### KEYMAPS

" remap of ctrl-c and ctrl-v : make ctrl-q input chars like ctrl-v did
" already setup by default, no need to redo it
"noremap! <C-Q>  <C-V>

" Select lines with shift+arrow
"inoremap <S-right> <C-o>v<right>
"nnoremap <C-S-right> vw
"inoremap <C-S-right> <C-o>vw
"vnoremap <C-S-right> w
"nnoremap <C-S-left> vb
"inoremap <C-S-left> <C-o>vb
"vnoremap <C-S-left> b

" use system clipboard to yank from other applications in gvim
"set clipboard=unnamedplus
"set clipboard=unnamed

" Allow backspacing over everything in insert mode
set bs=2

" Allow usage of cursor keys within insert mode
set esckeys

" copy/cut/paste with alt-c/x/v
"vnoremap <A-c> y
"inoremap <A-c> <esc>pi<right>
"vnoremap <A-x> x
"nnoremap <A-v> P

" Make backspace work
set t_kb=

" And do not confuse backspace with ctrl-backspace
"map ^H X

" Make 'Remove Character Under The Cursor' (DEL) work
map! <Esc>[3~ <Delete>
map  <ESC>[3~    x   

" FIXME: redo for msys2
" Make ctrl-backspace work :
inoremap <C-H> <C-O>b<C-O>dw
noremap <C-H> bdw
" Make ctrl-delete work
inoremap <ESC>[3;5~ <C-O>dw
noremap  <ESC>[3;5~    daw

" cool ones: ctrl-t tabulate, ctrl-d detabulate
" ctrl-i indent, ctrl-n 

" free:
" ctrl-f
"inoremap <C-F> <C-O>:promptfind<CR>
" ctrl-l
noremap <C-L>:setlocal shiftwidth=20<CR>setlocal softtabstop=20<CR>setlocal tabstop=20<CR>
" ctrl-w j to tab between separated windows from :sp
" 2 ctrl-w _ to make a window 2 lines tall

" ctrl-v
"inoremap <C-V> <C-O>:promptrepl<CR> 

" ctrl-v with bracketed-paste 
if exists("g:loaded_bracketed_paste")
  finish
endif
let g:loaded_bracketed_paste = 1

"let &t_ti .= "\<Esc>[?2004h"
let &t_ti .= "\e[?2004h"
let &t_te = "\e[?2004l" . &t_te

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

" ctrl-s : save
command -nargs=0 -bar Update if &modified 
\|    if empty(bufname('%'))
\|        browse confirm write
\|    else
\|        confirm write
\|    endif
\|endif
noremap <silent> <C-S> :<C-u>Update<CR>
inoremap <C-S> <C-O>:<C-u>Update<CR>

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" OSX
if &term=="xterm" || &term=="xterm-color"
" OSX Option-horizontal
     :imap f <C-Right>
     :imap b <C-Left>
     :nmap f <C-Right>
     :nmap b <C-Left>
" OSX Option-vertical
"     :imap <C-A> <C-Home>
"     :imap <C-E> <C-End>
     :imap <C-A> <C-O>{
     :imap <C-E> <C-O>}
     :nmap <C-A> <C-O>{
     :nmap <C-E> <C-O>}
endif

" Defaults from suse to try and get the correct main terminal type
if &term =~ "xterm"
    let myterm = "xterm"
else
    let myterm =  &term
endif
let myterm = substitute(myterm, "cons[0-9][0-9].*$",  "linux", "")
let myterm = substitute(myterm, "vt1[0-9][0-9].*$",   "vt100", "")
let myterm = substitute(myterm, "vt2[0-9][0-9].*$",   "vt220", "")
let myterm = substitute(myterm, "\\([^-]*\\)[_-].*$", "\\1",   "")

" Here we define the keys of the NumLock in keyboard transmit mode of xterm
" which misses or hasn't activated Alt/NumLock Modifiers.  Often not defined
" within termcap/terminfo and we should map the character printed on the keys.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <ESC>Oo  :
    map! <ESC>Oj  *
    map! <ESC>Om  -
    map! <ESC>Ok  +
    map! <ESC>Ol  ,
    map! <ESC>OM  
    map! <ESC>Ow  7
    map! <ESC>Ox  8
    map! <ESC>Oy  9
    map! <ESC>Ot  4
    map! <ESC>Ou  5
    map! <ESC>Ov  6
    map! <ESC>Oq  1
    map! <ESC>Or  2
    map! <ESC>Os  3
    map! <ESC>Op  0
    map! <ESC>On  .
    " keys in normal mode
    map <ESC>Oo  :
    map <ESC>Oj  *
    map <ESC>Om  -
    map <ESC>Ok  +
    map <ESC>Ol  ,
    map <ESC>OM  
    map <ESC>Ow  7
    map <ESC>Ox  8
    map <ESC>Oy  9
    map <ESC>Ot  4
    map <ESC>Ou  5
    map <ESC>Ov  6
    map <ESC>Oq  1
    map <ESC>Or  2
    map <ESC>Os  3
    map <ESC>Op  0
    map <ESC>On  .
endif

" xterm but without activated keyboard transmit mode
" and therefore not defined in termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>[H  <Home>
    map! <Esc>[F  <End>
    " Home/End: older xterms do not fit termcap/terminfo.
    map! <Esc>[1~ <Home>
    map! <Esc>[4~ <End>
    " Up/Down/Right/Left
    map! <Esc>[A  <Up>
    map! <Esc>[B  <Down>
    map! <Esc>[C  <Right>
    map! <Esc>[D  <Left>
    " KP_5 (NumLock off)
    map! <Esc>[E  <Insert>
    " PageUp/PageDown
    map <ESC>[5~ <PageUp>
    map <ESC>[6~ <PageDown>
    map <ESC>[5;2~ <PageUp>
    map <ESC>[6;2~ <PageDown>
    map <ESC>[5;5~ <PageUp>
    map <ESC>[6;5~ <PageDown>
    " keys in normal mode
    map <ESC>[H  0
    map <ESC>[F  $
    " Home/End: older xterms do not fit termcap/terminfo.
    map <ESC>[1~ 0
    map <ESC>[4~ $
    " Up/Down/Right/Left
    map <ESC>[A  k
    map <ESC>[B  j
    map <ESC>[C  l
    map <ESC>[D  h
    " KP_5 (NumLock off)
    map <ESC>[E  i
    " PageUp/PageDown
    map <ESC>[5~ 
    map <ESC>[6~ 
    map <ESC>[5;2~ 
    map <ESC>[6;2~ 
    map <ESC>[5;5~ 
    map <ESC>[6;5~ 
endif

" xterm/kvt but with activated keyboard transmit mode.
" Sometimes not or wrong defined within termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>OH <Home>
    map! <Esc>OF <End>
    map! <ESC>O2H <Home>
    map! <ESC>O2F <End>
    map! <ESC>O5H <Home>
    map! <ESC>O5F <End>
    " Cursor keys which works mostly
    " map! <Esc>OA <Up>
    " map! <Esc>OB <Down>
    " map! <Esc>OC <Right>
    " map! <Esc>OD <Left>
    map! <Esc>[2;2~ <Insert>
    map! <Esc>[3;2~ <Delete>
    map! <Esc>[2;5~ <Insert>
    map! <Esc>[3;5~ <Delete>
    map! <Esc>O2A <PageUp>
    map! <Esc>O2B <PageDown>
    map! <Esc>O2C <S-Right>
    map! <Esc>O2D <S-Left>
    map! <Esc>O5A <PageUp>
    map! <Esc>O5B <PageDown>
    map! <Esc>O5C <S-Right>
    map! <Esc>O5D <S-Left>
    " KP_5 (NumLock off)
    map! <Esc>OE <Insert>
    " keys in normal mode
    map <ESC>OH  0
    map <ESC>OF  $
    map <ESC>O2H  0
    map <ESC>O2F  $
    map <ESC>O5H  0
    map <ESC>O5F  $
    " Cursor keys which works mostly
    " map <ESC>OA  k
    " map <ESC>OB  j
    " map <ESC>OD  h
    " map <ESC>OC  l
    map <Esc>[2;2~ i
    map <Esc>[3;2~ x
    map <Esc>[2;5~ i
    map <Esc>[3;5~ x
    map <ESC>O2A  ^B
    map <ESC>O2B  ^F
    map <ESC>O2D  b
    map <ESC>O2C  w
    map <ESC>O5A  ^B
    map <ESC>O5B  ^F
    map <ESC>O5D  b
    map <ESC>O5C  w
    " KP_5 (NumLock off)
    map <ESC>OE  i
endif

if myterm == "linux"
    " keys in insert/command mode.
    map! <Esc>[G  <Insert>
    " KP_5 (NumLock off)
    " keys in normal mode
    " KP_5 (NumLock off)
    map <ESC>[G  i
endif

" /suse


" ####################### START AND STOP

" Use Vim defaults (much better!)
set nocompatible

" avoid warning for wrong version :
version 4.0

" Prevent modelines in files from being evaluated (avoids a potential
" security problem wherein a malicious user could write a hazardous
" modeline into a file) (override default value of 5)
set modelines=0

" Filename associated with the current edit buffer in the xterm title
let &titlestring = expand ("%:p:~:.:h")

" No beeps
set noerrorbells
set visualbell
set t_vb=

" Automatically save modifications to files
set autowrite

" No ~backups
set nobackup

" Writebackup
set nowritebackup

" Don't clear the screen upon exit
set t_ti=
set t_te=

" Ignore filename with any of these suffixes using :e
set suffixes=.aux,.bak,.dvi,.idx,.log,.ps,.swp,.tar

" ####################### EDITION

" Show line
set nu
"se nu!

" Shown hidden characters: tabs, eol
"set list

" For terminal emulators with mouse support
behave xterm
set selectmode=mouse

" Mouse setting
" set mouse=a

" Hide the mouse pointer while typing
set mousehide

" Wildmenu
set wildmenu

" Complete longest common string, then each full match
" enable this for bash compatible behaviour
" set wildmode=longest,full

" Off since I usually prefer perltidy
set noautoindent
set smartindent
set expandtab

" Show matching parenthesis
set showmatch

" always show 4 lines of context
set scrolloff=4

" Insert two spaces after a period with every joining of lines
set joinspaces

" Line warping
set nowrapscan

" Do not jump to first character with page commands
set nostartofline

" Allow jump commands for left/right motion to wrap to previous/next
" line when cursor is on first/last character in the line
set whichwrap=<,>,h,l,[,]

" Make the text wrap to the next line when it is X letters from the end
"set wrapmargin=8

" Always limit the width of text
"set tw=72

" ####################### SEARCH & REPLACE

" Show matches while incrementially searching
set incsearch

" Hilight search strings
set hlsearch

" Ignore the case in search patterns, required for smartcase
set ignorecase
" Default to ignore case, can restore with /searchsomething\c
set smartcase


" ####################### SYNTAX

" Comments default: sr:/*,mb:*,el:*/,://,b:#,:%,:XCOMM,n:>,fb:-
""set comments=b:#,:%,fb:-,n:>,n:)

" English words first
"set dictionary=/usr/dict/words,/usr/lib/ispell/spanish.words
" to start spelling on the local buffer
":setlocal spell spelllang=en_us
" then move around errors with ]s=next [s=prev,
# add to dict with zg
# mark as incorrect with zw
# give a list of possible fixes with z=

" Compose key for accents/8 bits chars/unicode
"set digraph

"  Options for the "text format" command ("gq")
set formatoptions=cqrto

" Hilight : 8b,db,es,hs,mb,Mn,nu,rs,sr,tb,vr,ws
"set highlight=8r,db,es,hs,mb,Mr,nu,rs,sr,tb,vr,ws

" hilight the current line
set cursorline

" Add the dash ('-'), the dot ('.'), and the '@' as "letters" to "words".
set iskeyword=@,48-57,_,192-255,-,.,@-@

" Program to use for the "K" command
" set keywordprg=man\ -s

" ####################### CSCOPE

" cscope vim interface
if has ("cscope")
        set cscopetag
        set csto=0
        if filereadable("cscope.out")
                cs add cscope.out
        endif

        set cscopeverbose
endif

" The following maps all invoke one of the following cscope search types:
"
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
"
" Below are three sets of the maps: one set that just jumps to your
" search result, one that splits the existing vim window horizontally and
" diplays your search result in the new window, and one that does the same
" thing, but does a vertical split instead (vim 6 only).
"
" I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
" unlikely that you need their default mappings (CTRL-\'s default use is
" as part of CTRL-\ CTRL-N typemap, which basically just does the same
" thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
" If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
" of these maps to use other keys.  One likely candidate is 'CTRL-_'
" (which also maps to CTRL-/, which is easier to type).  By default it is
" used to switch between Hebrew and English keyboard mode.
"
" All of the maps involving the <cfile> macro use '^<cfile>$': this is so
" that searches over '#include <time.h>" return only references to
" 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
" files that contain 'time.h' as part of their name).


" To do the first type of search, hit 'CTRL-\', followed by one of the
" cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
" search will be displayed in the current window.  You can use CTRL-T to
" go back to where you were before the search.  

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

" ####################### COMMAND LINE

" Use magic patterns (extended regular expressions)
set magic
" The char used for "expansion" on the command line
set wildchar=<TAB>

" Function to show the file creation date
function! FileTime()
  let ext=tolower(expand("%:e"))
  let fname=tolower(expand('%<'))
  let filename=fname . '.' . ext
  let msg=""
  let msg=msg." ".strftime("@%Y-%m-%d %H:%M:%S",getftime(filename))
  return msg
endfunction

" Function to get the git branch
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction
function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?' ^'.l:branchname.' ':''
endfunction

" ####################### AT THE BOTTOM OF THE SCREEN: STATUSLINE
" Statusline with colors and display of options
" at the bottom of the screen?
"set statusline=%t%{StatuslineGit()}%{FileTime()}\ %{&fenc==\"\"?&enc:&fenc},%{&bomb}\%a%=\ %8l,%c%V/%L\ %{&ff==\"dos\"?\"CRLF\":\"LF\"}\ %P\ %08O:%02B
" Show position of the cursor?
set noruler
"set ruler
" Show mode
"set showmode
set noshowmode
" Show current uncompleted command
"set showcmd
set noshowcmd
" Make command line two lines high
" set ch=2
" Always show status line, even for only one buffer.
"set laststatus=2
" Don't show anything and hide the line too
set laststatus=0

" ####################### AT THE TOP OF THE SCREEN: TABLINE
" need a autocommand to be dynamic
autocmd CursorMoved * :redrawtabline
" FIXME: too slow when using StatuslineGit() : inserts AAA DDD from moving the cursor
" try to fix at file load
"set tabline=%t%{StatuslineGit()}%{FileTime()}\ %{&fenc==\"\"?&enc:&fenc},%{&bomb}\%a%=\ %4l,%c%V/%L\ %{&ff==\"dos\"?\"CRLF\":\"LF\"}\ %P\ %08O:%02B
set tabline=%t%{FileTime()}\ \%{&fenc==\"\"?&enc:&fenc},%{&bomb}\%a%=\ %4l,%c%V/%L\ %{&ff==\"dos\"?\"CRLF\":\"LF\"}\ %P\ %08O:%02B
set showtabline=2

" Show tab/spaces invisible chars
"set list

" ####################### COLOR

if has("terminfo")
"    set t_Co=8
    set t_Sf=[3%p1%dm
    set t_Sb=[4%p1%dm
 else
"    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
endif

" Color
if &t_Co > 1
   syntax on
endif

" Leave the background and style autodetects on
if has('gui_running')
 set background=dark
 let g:solarized_style="dark"
" set guifont=Menlo\ Regular:h24
 set guifont=Monospace\ 13
else
" for solarized, 256 color from rxvt-unicode-256color and xterm-256color
" is better than nothing
" is worse when the palette has been replaced
" can kill italics/bold/underline if not overriding with g:solarized_italic=1
" but it avoid tweakings with the standard colors assignations
 if match($TERM, "rxvt-unicode-256color")==0
" For urxvt
  set background=dark
"  set background=light
"  let g:solarized_style="light"
" Tweakings are required on Linux, but are better than 256 color fallback
"  let g:solarized_termcolors=256
  let g:solarized_termtrans = 1
  let g:solarized_termcolors=16
 elseif match($TERM, "rxvt-unicode")==0
" For rxvt
 " set background=light
  set background=dark
  " let g:solarized_style="light"
  let g:solarized_termcolors=16
" No tweakings are required on Windows as the 256 color fallback looks good
 elseif match($TERM, "xterm-256color-italic")==0
  set background=light
  let g:solarized_style="light"
  let g:solarized_termcolors=256
  " Using 256 colors kills italics without that
  let g:solarized_italic=1
  let g:solarized_bold=1
  let g:solarized_underline=1
  " when showing EOL with :set list
  let g:solarized_visibility="low"
  let g:solarized_hitrail=1 
 elseif match($TERM, "xterm-256color")==0
  set background=light
  let g:solarized_style="light"
  let g:solarized_termcolors=256
 elseif match($TERM, "xterm")==0
  set background=dark
  let g:solarized_style="dark"
  let g:solarized_termtrans = 1
  let g:solarized_termcolors=16
 elseif match($TERM, "screen")==0
  let g:solarized_termtrans = 1
  let g:solarized_termcolors=16
  set background=dark
 elseif match($TERM, "sixel-tmux")==0
  set background=light
  let g:solarized_style="light"
  let g:solarized_termcolors=256
  let g:solarized_italic=1
  let g:solarized_underline=1
  let g:solarized_visibility="low"
  let g:solarized_hitrail=1 
 elseif match($TERM, "mintty")==0
  set background=light
  let g:solarized_style="light"
  let g:solarized_termcolors=256
  let g:solarized_bold=1
  let g:solarized_underline=1
  let g:solarized_visibility="low"
  let g:solarized_hitrail=1 
 endif
endif

" Solarized color scheme
colorscheme solarized
" Another option is solarized8

" Vim doesn't know the escape codes to switch to italic
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
" Italics auto toggle
if match($TERM, "xterm-256color-italic")==0
 highlight Comment cterm=italic
elseif match($TERM, "sixel-tmux")==0
 highlight Comment cterm=italic
elseif match($TERM, "mintty")==0
 highlight Comment cterm=italic
endif

" Set colors
"hi statusline   term=NONE    cterm=NONE  ctermfg=yellow  ctermbg=red
"hi statuslineNC term=NONE    cterm=NONE  ctermfg=white   ctermbg=black
"hi nontext      term=NONE    cterm=NONE  ctermfg=red     ctermbg=blue
"hi cursor       guifg=NONE   guibg=green
"hi special      guifg=NONE   guibg=grey95
"hi constant     guifg=NONE   guibg=grey95
"hi normal       guibg=black  guifg=white
"hi search       guibg=white  guifg=red   ctermfg=white   ctermbg=red
"hi comment                               ctermfg=cyan    ctermbg=black
" User1: color for buffer number
"hi User1 cterm=NONE ctermfg=red   ctermbg=black guifg=red   guibg=black
" User2: color for filename
"hi User2 cterm=NONE ctermfg=green ctermbg=black guifg=green guibg=black
" User3: color for position
"hi User3 cterm=NONE ctermbg=green  ctermbg=black guifg=green  guibg=black

" ####################### ABBREVIATIONS

" Abbreviations for some important numbers:
"iab Npi 3.1415926535897932384626433832795028841972
"iab Ne  2.7182818284590452353602874713526624977573

" Yalpha : The lower letter alphabet.
iab Yalpha abcdefghijklmnopqrstuvwxyz

" YALPHA : The upper letter alphabet.
iab YALPHA ABCDEFGHIJKLMNOPQRSTUVWXYZ

" Ydigit : The ten digits.
iab Ydigit  1234567890

" Yruler : A "ruler" - nice for counting the length of words
iab Yruler  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

" Yi18n: .123456789012345678. - yup, 18 characters betwwen 'i' and 'n'
iab Yi18n  internationalization

" Header Lines for Email and News
cab HEMAIL ^\(From\\|Cc\\|To\\|Date\\|Subject\\|Message-ID\\|Message-Id\\|X-\)
cab HNEWS  ^\(From\\|Cc\\|To\\|Date\\|Subject\\|Message-ID\\|X-\\|Newsgroups\)

" Date
iab Ydate <C-R>=strftime("%Y-%m-%d %H:%M")<CR>

if !has("unix")
iab Ydate2 <C-R>=strftime("%c %a")<CR>
else
iab Ydate2 <C-R>=strftime("%D %T %a")<CR>
endif

" New .pl
iab Yperl #!/usr/bin/perluse Carp qw(croak);use Data::Dumper;use warnings;use strict;

" ####################### General Editing

"      ,cel = "clear empty lines"
"       - delete the *contents* of all lines which contain only whitespace.
"         note:  this does not delete lines!
  map ,cel :%s/^\s\+$//

"      ,del = "delete 'empty' lines"
"       - delete all lines which contain only whitespace
"         note:  this does *not* delete empty lines!
  map ,del :g/^\s\+$/d

"      ,cqel = "clear quoted empty lines"
"       Clears (makes empty) all lines which start with '>'
"       and any amount of following spaces.
  nmap ,cqel :%s/^[>]\+$//
  vmap ,cqel  :s/^[><C-I> ]\+$//

"      ,gary = "index text in replies where TAB or spaces were used"
  vmap ,gary :s/^>[ <C-I>]\+\([^>]\)/> \1/

"      ,ksr = "kill space runs"
"       Substitutes runs of two or more space to a single space:
  nmap ,ksr :%s/  \+/ /g
  vmap ,ksr  :s/  \+/ /g

"    ,Sel = "squeeze empty lines"
"    Convert blocks of empty lines (not even whitespace included)
"    into *one* empty line (within current visual):
   map ,Sel :g/^$/,/./-j

"    ,Sbl = "squeeze blank lines"
"    Convert all blocks of blank lines (containing whitespace only)
"    into *one* empty line (within current visual):
   map ,Sbl :g/^\s*$/,/\S/-j

"      ,dp = de-quote current inner paragraph
   map ,dp vip:s/^> //<CR>
  vmap ,dp    :s/^> //<CR>

"      ,qp = quote current inner paragraph (works since vim-5.0q)
"            select inner paragraph then do the quoting as a substitution
   map ,qp   vip:s/^/> /<CR>

"      ,qp = quote current paragraph just do the quoting as a substitution:
  vmap ,qp    :s/^/> /<CR>

"       ## = comment current inner paragraph with '#':
  nmap  ##   vip:s/^/#<space>/<CR>
  vmap  ##      :s/^/#<space>/<CR>

"      ,kpq kill power quote
"       Fix Supercite aka PowerQuote (Hi, Andi! :-):
"       before ,kpq:    >   Sven> text
"       after  ,kpq:    > > text
  vmap ,kpq :s/^> *[a-zA-Z]*>/> >/<C-M>

"      ,fq "fix quoting"
"       Fix various other quote characters:
  vmap ,fq :s/^> \([-":}\|][ <C-I>]\)/> > /

" These mappings make use of the abbreviation that define a list of
" Email headers (HEMAIL) and News headers (HNEWS):
  nmap ,we vip:v/HEMAIL/d
  vmap ,we    :v/HEMAIL/d
  nmap ,wp vip:v/HNEWS/d
  vmap ,wp    :v/HNEWS/d

"      ,b = break line in commented text (to be used on a space)
  nmap ,b r<CR>

"      ,j = join line in commented text (can be used anywhere on the line)
" nmap ,j Jxx
  nmap ,j Vjgq

"      ,B = break line at current position *and* join the next line
" nmap ,B i<CR>><ESC>Jxx
  nmap ,B r<CR>Vjgq

"     ,ca = check alias (reads in expansion of alias name)
" map ,ca :r!elmalias -f "\%v (\%n)"

"     ,Ca = check alias (reads in expansion of alias name)
" map ,Ca :r!elmalias -f "\%n <\%v>"

"   ,cc = "copy notice"
"   Insert a Cc line so that person will receive a "courtesy copy";
  map ,cc 1G}jyykPICc: <ESC>$x

"     ,mlu = make letter urgent  (by giving the "Priority: urgent")
  map ,mlu 1G}OPriority: urgent<ESC>

"     ,re : Condense multiple "Re:_" to just one "Re:":
  map ,re 1G/^Sub<CR>:s/\(Re: \)\+/Re: /<CR>

"     ,Re : Change "Re: Re[n]" to "Re[n+1]" in Subject lines:
  map ,Re 1G/^Subject: <C-M>:s/Re: Re\[\([0-9]\+\)\]/Re[\1]/<C-M><C-A>

"     ,( Put parentheses around "visual text"
  vmap ,( v`<i(<ESC>`>a)<ESC>
  vmap ,) v`<i(<ESC>`>a)<ESC>

"     ,kqs = kill quoted sig (to remove those damn sigs for replies)
"          goto end-of-buffer, search-backwards for a quoted sigdashes
"          line, ie "^> -- $", and delete unto end-of-paragraph:
  map ,kqs G?^> -- $<CR>d}

"     #b = "browse" - send selected URL to Netscape
 vmap #b y:!firefox -new-tab "<C-R>""

" ####################### AUTOCOMMANDS

if has("autocmd")

" When editing a file, always jump to the last known cursor position. 
" Don't do it when the position is invalid or when inside an event handler 
" (happens when dropping a file on gvim). 
autocmd BufReadPost *
 \ if line("'\"") > 0 && line("'\"") <= line("$") |
 \   exe "normal g`\"" |
 \ endif

"augroup gzip
"  au!
"  autocmd BufReadPre,FileReadPre        *.gz set bin
"  autocmd BufReadPost,FileReadPost      *.gz '[,']!gunzip
"  autocmd BufReadPost,FileReadPost      *.gz set nobin
"  autocmd BufReadPost,FileReadPost      *.gz execute ":doautocmd BufReadPost " .  expand("%:r")
"
"  autocmd BufWritePost,FileWritePost    *.gz !mv <afile> <afile>:r
"  autocmd BufWritePost,FileWritePost    *.gz !gzip <afile>:r

"  autocmd FileAppendPre                 *.gz !gunzip <afile>
"  autocmd FileAppendPre                 *.gz !mv <afile>:r <afile>
"  autocmd FileAppendPost                *.gz !mv <afile> <afile>:r
"  autocmd FileAppendPost                *.gz !gzip <afile>:r
"augroup END

augroup bzip
  au!
  autocmd BufReadPre,FileReadPre        *.bz2 set bin
  autocmd BufReadPost,FileReadPost      *.bz2 '[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 set nobin
  autocmd BufReadPost,FileReadPost      *.bz2 execute ":doautocmd BufReadPost " .  expand("%:r")

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 <afile>:r
augroup END

augroup html
"  autocmd BufWritePost			*.html :!netscape -remote "reload()"
  autocmd BufEnter			*.html :noremap <F3> :!netscape -remote "openURL(file:%)"^M^M
  autocmd BufEnter			*.html :inoremap <F3> ^[^[:!netscape -remote "openURL(file:%)"^M^Ma
"  autocmd BufWritePost			*.css :!netscape -remote "reload()"
  autocmd BufEnter			*.css :noremap <F3> :!netscape -remote "reload()"^M^M
  autocmd BufEnter			*.css :inoremap <F3> ^[^[:!netscape -remote "reload()"^M^Ma

augroup END

augroup cprog
  au!
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

endif " has("autocmd")

" Highlight a column in csv text.
" :Csv 1    " highlight first column
" :Csv 12   " highlight twelfth column
" :Csv 0    " switch off highlight
function! CSVH(colnr)
  if a:colnr > 1
    let n = a:colnr - 1
    execute 'match Keyword /^\([^,]*,\)\{'.n.'}\zs[^,]*/'
    execute 'normal! 0'.n.'f,'
  elseif a:colnr == 1
    match Keyword /^[^,]*/
    normal! 0
  else
    match
  endif
endfunction
command! -nargs=1 Csv :call CSVH(<args>)
