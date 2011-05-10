" .vimrc
"
"set background=light
"set nocompatible  "Really important option, must be first
set wildmenu
set history=50
set showcmd
set showmode
set showmatch
syntax on
set hlsearch
set smartindent
set textwidth=72
set ruler
set backspace=2
set shiftwidth=4
set smarttab
set softtabstop=4
set tabstop=4
set modeline 
set modelines=3
set backupdir=/tmp
set whichwrap=b,s
set viminfo='1000,f1,\"500
" disabled, this are the digraphs made with {char} <backspace> {char}
"set digraph
set noerrorbells
set laststatus=2
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set t_Co=256 " number of colors in terminal, default=88
set hidden
set pastetoggle=<F2> " switch to paste mode with F2
set spelllang=en,it,es,pt
set formatoptions=tcqw " some formatting options, see fo-table
set wildignore=*.swp,*.bak,*.pyc	" ignore those file extensions when Tab completing
set printoptions=header:0

"persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=500 " maximum number of changes that can be undone
set undoreload=10000 " maximum number of lines to save for undo on a buffer reload

"set guifontset=-adobe-courier-medium-r-normal-*-10-*-*-*-*-*-iso10646-1
filetype plugin on
filetype plugin indent on
" set a color scheme
"color desert
"color gianluca
color twilight256

" custom statusline
if has('statusline')
	let &stl="[%f]\ ft=%{&ff}\ t=%Y\ ascii=\%04.8b\ hex=\%04.4B\ %04l,%04v[%p%%]"
endif

" no automatic highlighting of brackets and such
"let loaded_matchparen = 1
"
" save fold before closing
au BufWinLeave * mkview
au BufWinEnter * silent! loadview
"
" --- MAIL ---
"
if has("autocmd")
    autocmd FileType mail set fo=tcrqw textwidth=72 
    autocmd FileType mail call Mail_AutoCmd()
endif
" set mail fileformat for mails, mboxes and news messages
au BufRead,BufNewFile /tmp/mutt-*,~/Maildir/.*,.followup*,.article* :set ft=mail 
" various functions for mail and news
function Mail_AutoCmd()
    silent! %s/^\(>*\)\s\+>/\1>/g " wrong quoting
    silent! %s/^> >/>>/ " wrong quoting 2
    silent! %s/  \+/ /g " multiple spaces
    silent! %s/^\s\+$//g " rows with only spaces
    silent! %s/^[>]\+$// " empty quoted rows
endfunction
" some mappings
"
" delete rows with just spaces
map ,del :%s/^\s\+$//g
" delete empty rows (not even with spaces)
map ,delempty :%s/^\n//g
" delete empty quoted rows
nmap ,ceql :%s/^[>]\+$//
nmap ,cqel :%s/^> \s*$//<CR>^M
vmap ,ceql :s/^[><C-I> ]\+$//
" delete quoted rows with only spaces
map ,qesl :%s/^[>]\s\+$//g
" substitute a dot with various spaces with a single dot and 2 spaces
vmap ,dotsub :s/\.\+ \+/.  /g
" substitute multiple spaces with just one
nmap ,ksr :%s/  \+/ /g
vmap ,ksr :s/  \+/ /g
" substitute various consecutive empty rows with just one
map ,emptyblock :g/^$/,/./-j
" as above but with rows of only spaces
map ,Sbl :g/^\s*$/,/\S/-j
" regroup multiple Re:
map ,re 1G/^Subject: <CR>:s/\(Re: \)\+/Re: /e<CR>^M
" delete yahoo group links
map ,delgyah :g#^>\? http://docs.yahoo#.-10,.d
" delete every header
map ,noheader :0,/^$/d
"
" --- MAIL END ---
"
"
" --- PROGRAMMING ---
if has("autocmd")
	augroup Python
		" some options for python files
		autocmd FileType python setlocal textwidth=0
		autocmd FileType python setlocal tabstop=4
		autocmd FileType python setlocal expandtab " spaces instead of tabs
		autocmd FileType python setlocal softtabstop=4 " treat 4 spaces as a tab
		" different statusline, thanks to pythonhelper.vim, for python files
		autocmd FileType python  let &stl="[%f]\ ft=%{&ff}\ t=%Y\ ascii=\%04.8b\ hex=\%04.4B\ %04l,%04v[%p%%] def=%{TagInStatusLine()}"
		" call pydoc with the name of the python module from which we want
		" help
		:command -nargs=+ Pyhelp :call ShowPydoc("<args>")
		function ShowPydoc(module, ...)
			let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
			execute ":!pydoc " . a:module . " > " . fPath
			execute ":sp " .fPath
		endfunction
		autocmd FileType python set omnifunc=pythoncomplete#Complete
		" folding follow indentation
		autocmd FileType python set foldmethod=indent
		autocmd FileType python set foldlevel=99
	augroup END

	augroup Ruby
		" some options for ruby files
		autocmd FileType ruby setlocal tabstop=2
		autocmd FileType ruby setlocal textwidth=80 
		autocmd FileType ruby set omnifunc=rubycomplete#Complete
	augroup END

    " no tabs in spaces for make files
    autocmd FileType make set noexpandtab shiftwidth=8
    " enable function-complete for supported files
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	autocmd FileType lua set omnifunc=luacomplete#Complete
    " Max 78 characters for line in text files
    autocmd BufRead *.txt set tw=78
	" No limit of characters for line in csv files
	autocmd BufRead *.csv set tw=0
    " make every script executable
    autocmd BufWritePost * if getline(1) =~ "^#!/" | silent exe "!chmod u+x <afile>" | endif
	" add vim options at the end of every script (currently not working)
    "autocmd BufWritePost * if getline(1) =~ "^#!/" && if getline($) =~ "^# vi" | silent :$s/^/# vim: set ft=sh tw=0:/ | endif
    " enable editing of gzipped files
    augroup gzip
	" delete first every autocmd
	au!

	autocmd BufReadPre,FileReadPre  *.gz set bin
	autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
	autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
	autocmd BufReadPost,FileReadPost	*.gz set nobin
	autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
	autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " - expand("%:r")
	autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
	autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r
	autocmd FileAppendPre   *.gz !gunzip <afile>
	autocmd FileAppendPre   *.gz !mv <afile>:r <afile>
	autocmd FileAppendPost  *.gz !mv <afile> <afile>:r
    augroup END
endif
"
" comments' functions
function! ShellComment()
    map - :s/^/#/<CR>
    map _ :s/^\s*#\=//<CR>
    set comments=:#
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap # X#
endfunction

function! CComment()
    map - :s/^/\/\*/<CR>
    map _ :s/^\s*\/\* \=//<CR>
    set comments=:/*
endfunction

function! LuaComment()
	map - :s/^/--/<CR>
	map _ :s/^\s*--//<CR>
	set comments=:--
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap - X-
endfunction

" ...and enabling them
if has("autocmd")
    autocmd FileType perl	call ShellComment()
    autocmd FileType cgi	call ShellComment()
    autocmd FileType sh		call ShellComment()
    autocmd FileType java	call ShellComment()
    autocmd FileType python	call ShellComment()
    autocmd FileType c,cpp	call CComment()
	autocmd FileType lua	call LuaComment()
endif

" --- PROGRAMMING END ---
"
" --- HTML E XML ---
" options for xml.vim (make tags compatible with xhtml)
let xml_use_xhtml=1	    
let xml_tag_completion_map = "<C-l>"
" use css for generated html files
let html_use_css=1

" --- Tex and Latex ---
"  settingf for vim-latex
"set grepprg=grep\ -nH\ $*
"let g:Imap_DeleteEmptyPlaceHolders=1
"let g:Tex_DefaultTargetFormat="pdf"
"let g:Tex_ViewRule_dvi="evince"
"let g:Tex_ViewRule_ps="evince"
"let g:Tex_ViewRule_pdf="evince"
"let g:Tex_MultipleCompileFormats="dvi,pdf,ps"

" --- VARIOUS STUFF ---
"
"  all the text on a single row
map ,line  :%s/\n/ /g
" save the buffer content in a temporary file with "_Y and import it
" back in another with "_P
nmap _Y :!echo ""> /tmp/.vi_tmp<CR><CR>:w! /tmp/.vi_tmp<CR>
vmap _Y :w! /tmp/.vi_tmp<CR>
nmap _P :r /tmp/.vi_tmp<CR>
" moving the cursor disables search highlighting
nmap j <Down>:nohls<CR>
nmap k <Up>:nohls<CR>
nmap h <Left>:nohls<CR>
nmap l <Right>:nohls<CR>
" Ctrl+hjkl to navigate in insert mode (Ctrl+j doesn't work, use Ctrl+u
" instead)
imap <C-u> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
imap <C-h> <Left>

" paste the content of clipboard on a new line, leave a empty line after
" it and return in normal mode
nmap ,u o<Esc>"*p<Esc>o<Esc>
" same as above but without a trailing new line
nmap ,U o<Esc>"*p<Esc>

"
" two , in insert mode to exit instead of Esc
imap ,, <Esc>
" modify the colors of not found dictionary words highlighting because
" sometimes changing terminal colors make them unreadable
" other similar options are: SpellCap SpellRare and SpellLocal
hi SpellBad term=reverse ctermfg=white ctermbg=darkred guifg=#FFFFFF guibg=#7F0000 gui=underline

" Aspell checking
map  :w!<CR>:!aspell -d it -x check %<CR>:e! %<CR>
map  :w!<CR>:!aspell -d en -x check %<CR>:e! %<CR>

" open link in the current row in the browser
function! Browser ()
    let line0 = getline (".")
    let line = matchstr (line0, "http[^ ]*")
    :if line==""
    let line = matchstr (line0, "ftp[^ ]*")
    :endif
    :if line==""
    let line = matchstr (line0, "file[^ ]*")
    :endif
    let line = escape (line, "#=?&;|%")
    if line==""
     let line = "\"" . (expand("%:p")) . "\""
    :endif
    exec ':silent !firefox ' . line 
endfunction

map ,w :call Browser ()<CR>

if has("autocmd")
	" grouping all autocmds

	" automatically ask for the password when opening a gpg file
	augroup encrypted
		au!

		" First make sure nothing is written to ~/.viminfo while editing
		" an encrypted file.
		autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
		" We don't want a swap file, as it writes unencrypted data to disk
		autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
		" Switch to binary mode to read the encrypted file
		autocmd BufReadPre,FileReadPre      *.gpg set bin
		autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
		autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
		autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
		autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
		autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg2 -q --decrypt --default-recipient-self 2> /dev/null
		autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave

		" Switch to normal mode for editing
		autocmd BufReadPost,FileReadPost    *.gpg set nobin
		autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
		autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

		" Convert all text to encrypted text before writing
		autocmd BufWritePre,FileWritePre    *.gpg set bin
		autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
		autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
		autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg2 -q --encrypt --default-recipient-self 2>/dev/null
		autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave

		" Undo the encryption so we are back in the normal text, directly
		" after the file has been written.
		autocmd BufWritePost,FileWritePost  *.gpg   silent u
		autocmd BufWritePost,FileWritePost  *.gpg set nobin
	augroup END

	" highlight cursor line when focus is gained
	function! HighlightCursor ()
		setlocal cursorline
		redraw
		sleep 1
		setlocal nocursorline
	endfunction

	" and auto call it
	" " currently disabled, it works only for gvim " "
	"autocmd! FocusGained * :call HighlightCursor()

	" autocmd for source.txt and 0000 files
	augroup bbformatting
		autocmd BufReadPre *source.txt silent! syntax off
		autocmd BufReadPre *0000 silent! syntax off
		autocmd BufWritePre,FileWritePre *source.txt silent! %s/^\s*//g
		autocmd BufWritePre,FileWritePre *0000 silent! %s/^\s*//g
		autocmd BufWritePre,FileWritePre *source.txt silent! :g/^\s*$/,/\S/-j
		autocmd BufWritePre,FileWritePre *0000 silent! :g/^\s*$/,/\S/-j
		autocmd BufWritePre,FileWritePre *source.txt silent! %s/^\n$//g
		autocmd BufWritePre,FileWritePre *0000 silent! %s/^\n$//g
		autocmd BufWritePre,FileWritePre *0000 silent! %s/URL\]\s*\n/URL\] /gi
		autocmd BufWritePre,FileWritePre *source.txt silent! %s/URL\]\s*\n/URL\] /gi
		autocmd BufWritePre,FileWritePre *0000 silent! %s/URL\][^[]*\[URL/URL\] \[URL/gi
		autocmd BufWritePre,FileWritePre *source.txt silent! %s/URL\][^[]*\[URL/URL\] \[URL/gi
		autocmd BufWritePre,FileWritePre *0000 silent! %s/<br>//gi
		autocmd BufWritePre,FileWritePre *source.txt silent! %s/<br>//gi
		autocmd BufWritePre,FileWritePre *0000 silent! %s/>[^<]*</></g
		autocmd BufWritePre,FileWritePre *source.txt silent! %s/>[^<]*</></g
		autocmd BufWritePre,FileWritePre *source.txt silent! %s/fonte/\rfonte/gi
	augroup END
endif
