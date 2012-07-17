set nocompatible	"Really important option, must be first
set history=50
set title			" show a nice title
set showcmd			" display incomplete commands
set showmode
set showmatch
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
set listchars=tab:»\ ,trail:·,nbsp:·
set nobackup
set nowritebackup
set backupdir=/tmp
set whichwrap=b,s
set viminfo='1000,f1,\"500
" disabled, this are the digraphs made with {char} <backspace> {char}
"set digraph
set noerrorbells
set autoread " auto reload files changed outside vim (but not if deleted)
set laststatus=2
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set hidden				" hide buffers when not displayed
set pastetoggle=<leader>tp	" switch to paste mode with ,tp
set spelllang=en,it,es,pt
set formatoptions=tcqw	" some formatting options, see fo-table
set wildmenu			" enable ctrl-n and ctrl-p to scroll through matches
set wildmode=longest,list,full
set wildignore=*.sw?,*.bak,*.pyc,*.luac,*.png,*.gif,*.jpg,*.zip,*.jar,*.rar	" ignore those file extensions when Tab completing
set printoptions=header:0,paper:A4,left:0.5in,right:0.5in,top:0.5in,bottom:0.5in
set pumheight=20
set ttyfast
let mapleader=","		" comma as <leader>

"persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=200		" maximum number of changes that can be undone
set undoreload=1000		" maximum number of lines to save for undo on a buffer reload

if has("autocmd")
	filetype plugin on
	filetype plugin indent on
	" resize splits when the window is resized
	au VimResized * :wincmd =
endif

" set a color scheme
if &t_Co == 256 || &t_Co == 88
	set t_Co=256		" number of colors in terminal, default=88
	color ubaryd
	"color laederon
else
	color desert
endif

" custom statusline
if has('statusline')
	let &stl="[%f]\ ft=%{&ff}\ t=%Y\ ascii=\%04.8b\ hex=\%04.4B\ %04l,%04v[%p%%]"
endif

" switch syntax highlighting on when the terminal has colours and also 
" highlights the last search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
	set incsearch
endif

" no automatic highlighting of brackets and such
"let loaded_matchparen = 1
"
" save fold before closing
au BufWinLeave * mkview
au BufWinEnter * silent! loadview

" Templates
augroup Templates
	au BufNewFile *.py 0read ~/.vim/skel/python.skel | normal G
	au BufNewFile *.tex 0r ~/.vim/skel/tex.skel | normal G
	au BufNewFile *.lua 0r ~/.vim/skel/lua.skel | normal G
	au BufNewFile *.asm 0r ~/.vim/skel/assembler.skel | normal G
	au BufNewFile 0000 silent! 0r ~/.vim/skel/0000
	au BufNewFile source.txt silent! 0r ~/.vim/skel/source.%:e
augroup END


"
" --- MAIL ---
"
if has("autocmd")
	autocmd FileType mail set fo=tcrqw textwidth=72 spell
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
noremap <leader>del :%s/^\s\+$//g
" delete empty rows (not even with spaces)
noremap <leader>delempty :%s/^\n//g
" delete empty quoted rows
nnoremap <leader>ceql :%s/^[>]\+$//
nnoremap <leader>cqel :%s/^> \s*$//<CR>^M
vnoremap <leader>ceql :s/^[><C-I> ]\+$//
" delete quoted rows with only spaces
noremap <leader>qesl :%s/^[>]\s\+$//g
" substitute a dot with various spaces with a single dot and 2 spaces
vnoremap <leader>dotsub :s/\.\+ \+/.  /g
" substitute multiple spaces with just one
nnoremap <leader>ksr :%s/  \+/ /g
vnoremap <leader>ksr :s/  \+/ /g
" substitute various consecutive empty rows with just one
noremap <leader>emptyblock :g/^$/<leader>/./-j
" as above but with rows of only spaces
noremap <leader>Sbl :g/^\s*$/<leader>/\S/-j
" regroup multiple Re:
noremap <leader>re :%s/Subject: \(Re\?: \)\+/Subject: Re: /g<CR>
" delete yahoo group links
noremap <leader>delgyah :g#^>\? http://docs.yahoo#.-10<leader>.d
" delete every header
noremap <leader>noheader :0<leader>/^$/d
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
		autocmd FileType python  let &stl="[%f]\ ft=%{&ff}\ t=%Y\ ascii=\%04.8b\ hex=\%04.4B\ %04l,%04v[%p%%] fun=%{TagInStatusLine()}"
		" call pydoc with the name of the python module from which we want
		" help
		:command -nargs=+ Pyhelp :call ShowPydoc("<args>")
		function ShowPydoc(module, ...)
			let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
			execute ":!pydoc " . a:module . " > " . fPath
			execute ":sp " .fPath
		endfunction
		" folding follow indentation
		autocmd FileType python set foldmethod=indent
		autocmd FileType python set foldlevel=99
	augroup END

	augroup C
		autocmd FileType c set makeprg=gcc\ -o\ %<\ %
		autocmd FileType c setlocal cindent
		ab #i #include
		ab #d #define
	augroup END

	augroup Ruby
		" some options for ruby files
		autocmd FileType ruby setlocal tabstop=2
		autocmd FileType ruby setlocal textwidth=80 
	augroup END

	augroup Markdown
		"" options for markdown files
		autocmd FileType markdown setlocal textwidth=0 spell
		nnoremap <leader>* i**<Esc>ea**<Esc>
		nnoremap <leader>_ i_<Esc>ea_<Esc>
	augroup END

	augroup Java
		" options for java files
		autocmd FileType java set shiftwidth=4
		autocmd FileType java set cindent
		autocmd FileType java set foldmethod=marker
		autocmd FileType java set foldmarker={,}
		autocmd FileType java let java_comment_strings=1
		autocmd FileType java let java_highlight_all=1
		autocmd FileType java let java_highlight_debug=1
		autocmd FileType java let java_highlight_java_lang_ids=1
		autocmd FileType java let java_ignore_javadoc=1
		autocmd FileType java let java_highlight_functions=1
		autocmd FileType java let java_mark_braces_in_parens_as_errors=1
		autocmd FileType java let java_minlines=150
	augroup END

	augroup Lisp
		" options for lisp files
		autocmd FileType lisp setlocal expandtab
		autocmd FileType lisp setlocal shiftwidth=2
		autocmd FileType lisp setlocal tabstop=2
		autocmd FileType lisp setlocal softtabstop=2
	augroup END

	augroup Haskell
		" options for haskell files
		autocmd FileType haskell setlocal expandtab tabstop=4 shiftwidth=4 textwidth=79
	augroup END

	augroup Html
		" options for html files
		autocmd FileType html setlocal expandtab
	augroup END

	if exists("+omnifunc")
		augroup Omnifunctions
			" enable function-complete for supported files
			autocmd FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
			autocmd FileType css set omnifunc=csscomplete#CompleteCSS
			autocmd FileType lua set omnifunc=luacomplete#Complete
			autocmd FileType java set omnifunc=javacomplete#Complete
			autocmd FileType ruby set omnifunc=rubycomplete#Complete
			autocmd FileType python set omnifunc=pythoncomplete#Complete
			autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
			autocmd FileType c set omnifunc=ccomplete#Complete
			" use syntax complete if nothing else available
			autocmd FileType * if &omnifunc == "" |
						\	setlocal omnifunc=syntaxcomplete#Complete |
						\	endif
		augroup END
	endif

	augroup filedetection
		" precise filetype settings
		autocmd BufRead,BufNewFile Gemfile,Rakefile,Thorfile,config.ru,Rules,Vagrantfile,Guardfile,Capfile set filetype=Ruby
		autocmd BufRead,BufNewFile *.json set filetype=json
		autocmd BufRead,BufNewFile *tmux.conf* set filetype=tmux
		autocmd BufRead,BufNewFile *.{md,mkd,mdown,markdown} set filetype=markdown
		autocmd BufRead,BufNewFile *.asm setlocal filetype=nasm
	augroup END

	" no tabs in spaces for make files
	autocmd FileType make set noexpandtab shiftwidth=8
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
	noremap - :s/^/#/<CR>
	noremap _ :s/^\s*#\=//<CR>
	set comments=:#
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap # X#
endfunction

function! XdefaultsComment()
	noremap - :s/^/!/<CR>
	noremap _ :s/^\s*!\=//<CR>
	set comments=:!
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap ! X!
endfunction

function! CComment()
	noremap - :s/^/\/\*/<CR> \| :s/$/ \*\//<CR> \| :nohls<CR>
	noremap _ :s/^\s*\/\* \=//<CR> \| :s/\s*\*\/$//<CR> \| :nohls<CR>
	set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
endfunction

function! LuaComment()
	noremap - :s/^/--/<CR>
	noremap _ :s/^\s*--//<CR>
	set comments=:--
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap - X-
endfunction

function! VimComment()
	noremap - :s/^/\"/<CR>
	noremap _ :s/^\s*\"//<CR>
	set comments=:\"
endfunction

function! LispComment()
	noremap - :s/^/\;/<CR>
	noremap _ :s/^\s*\;//<CR>
	set comments=:\;
endfunction

" ...and enabling them
if has("autocmd")
	autocmd FileType perl	call ShellComment()
	autocmd FileType cgi	call ShellComment()
	autocmd FileType sh		call ShellComment()
	autocmd FileType python	call ShellComment()
	autocmd FileType java	call CComment()
	autocmd FileType c,cpp	call CComment()
	autocmd FileType lua	call LuaComment()
	autocmd FileType sql	call LuaComment()
	autocmd FileType haskell call LuaComment()
	autocmd FileType vim	call VimComment()
	autocmd FileType lisp	call LispComment()
	autocmd FileType xdefaults call XdefaultsComment()
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
"let g:Tex_ViewRule_dvi="epdfview"
"let g:Tex_ViewRule_ps="epdfview"
"let g:Tex_ViewRule_pdf="epdfview"
"let g:Tex_MultipleCompileFormats="dvi,pdf,ps"

" --- VARIOUS STUFF ---
"
"  all the text on a single row
noremap <leader>line  :%s/\n/ /g
" save the buffer content in a temporary file with "_Y and import it
" back in another with "_P
nnoremap _Y :!echo ""> /tmp/.vi_tmp<CR><CR>:w! /tmp/.vi_tmp<CR>
vnoremap _Y :w! /tmp/.vi_tmp<CR>
nnoremap _P :r /tmp/.vi_tmp<CR>
" moving the cursor disables search highlighting
nnoremap j <Down>:nohls<CR>
nnoremap k <Up>:nohls<CR>
nnoremap h <Left>:nohls<CR>
nnoremap l <Right>:nohls<CR>
" Ctrl+hjkl to navigate in insert mode
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-h> <Left>
" Convert to html a markdown text
nnoremap <leader>mh :%!/usr/local/bin/markdownitall.lua %<CR>

" Add parentheses around current word; use it from the beginning
" of the word
nnoremap <leader>( i(<Esc>ea)<Esc>

" command line abbreviations
cabbrev Wq wq

" paste the content of clipboard on a new line, leave a empty line after
" it and return in normal mode
nnoremap <leader>u o<Esc>"*p<Esc>o<Esc>
" same as above but without a trailing new line
nnoremap <leader>U o<Esc>"*p<Esc>

" uppercase current word and return to insert mode
inoremap <c-u> <Esc>viwUi

"
" two , in insert mode to exit instead of Esc
inoremap ,, <Esc>
" modify the colors of not found dictionary words highlighting because
" sometimes changing terminal colors make them unreadable
" other similar options are: SpellCap SpellRare and SpellLocal
hi SpellBad term=reverse ctermfg=white ctermbg=darkred guifg=#FFFFFF guibg=#7F0000 gui=underline

" Aspell checking
noremap  :w!<CR>:!aspell -d it -x check %<CR>:e! %<CR>
noremap  :w!<CR>:!aspell -d en -x check %<CR>:e! %<CR>

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

	noremap ,w :call Browser ()<CR>

" Set up a writing environment for long text (not code!)
function! WritingMode()
	setlocal formatoptions=l
	setlocal noexpandtab
	set complete+=kspell
	setlocal wrap
	setlocal linebreak
endfunction
com! WritingMode call WritingMode()

	" open taglist
	nnoremap ,tag :TlistToggle<CR>
	" and close vi if it's the only window open
	let Tlist_Exit_OnlyWindow = 1

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
			au!
			autocmd FileReadPost *source.txt silent! syntax off setlocal nospell
			autocmd FileReadPost *0000 silent! syntax off setlocal nospell
			autocmd FileReadPost *source.mdown silent! syntax off setlocal nospell
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
			autocmd BufWritePre,FileWritePre *source.mdown silent! %s/URL\][^[]*\[URL/URL\] \[URL/gi
			autocmd BufWritePre,FileWritePre *0000 silent! %s/<br>//gi
			autocmd BufWritePre,FileWritePre *source.txt silent! %s/<br>//gi
			autocmd BufWritePre,FileWritePre *0000 silent! %s/>[^<]*</></g
			autocmd BufWritePre,FileWritePre *source.txt silent! %s/>[^<]*</></g
			autocmd BufWritePre,FileWritePre *source.txt silent! %s/fonte/\rfonte/gi
		augroup END
	endif
