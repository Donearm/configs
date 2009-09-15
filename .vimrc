"set background=light
"set nocp  "Really important option
set wildmenu
set history=50
set showcmd
set showmode
"set syntax=on
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

"set guifontset=-adobe-courier-medium-r-normal-*-10-*-*-*-*-*-iso10646-1
filetype plugin on
filetype plugin indent on
" l'opzione color imposta un colorscheme di default
"color desert
color gianluca

" statusline personalizzata
if has('statusline')
    let &stl="[%f]\ ft=%{&ff}\ t=%Y\ ascii=\%04.8b\ hex=\%04.4B\ %04l,%04v[%p%%]"
endif

" colorscheme da caricare se siamo in *rxvt
if has("autocmd")
    if &term == "rxvt-unicode"
	set background=light
	color desert
    endif
endif
"
" Elimina l'highlighting delle parentesi di default
"let loaded_matchparen = 1
" Preserva dopo la chiusura tutti i fold impostati
au BufWinLeave * mkview
au BufWinEnter * silent! loadview
"
" --- MAIL ---
" modifiche quando si edita una mail
if has("autocmd")
    autocmd FileType mail set fo=tcrqw textwidth=72 
    autocmd FileType mail call Mail_AutoCmd()
endif
" seleziono il formato mail per le caselle di posta e i messaggi di news 
" che apro
au BufRead,BufNewFile /tmp/mutt-*,~/Maildir/.*,.followup*,.article* :set ft=mail 
" Funzione di autocmd per mail e news
function Mail_AutoCmd()
    silent! %s/^\(>*\)\s\+>/\1>/g " quotazioni sbagliate
    silent! %s/^> >/>>/ " come sopra
    silent! %s/  \+/ /g " spazi multipli
    silent! %s/^\s\+$//g " linee con solo spazi
    silent! %s/^[>]\+$// " linee vuote quotate
endfunction
" elimina linee che contengono solo spazi
map ,del :%s/^\s\+$//g
" elimina linee vuote (senza neppure spazi)
map ,delempty :%s/^\n//g
" elimina linee vuote quotate
nmap ,ceql :%s/^[>]\+$//
nmap ,cqel :%s/^> \s*$//<CR>^M
vmap ,ceql :s/^[><C-I> ]\+$//
" elimina linee quotate contenenti solo spazi
map ,qesl :%s/^[>]\s\+$//g
" sostituisce i punti seguiti da vari spazi con punto-spazio-spazio
vmap ,dotsub :s/\.\+ \+/.  /g
" sostituisce più di uno spazio consecutivo con uno solo
nmap ,ksr :%s/  \+/ /g
vmap ,ksr :s/  \+/ /g
" sostituisce blocchi di più linee vuote con una sola linea
map ,emptyblock :g/^$/,/./-j
" stessa cosa di sopra ma con blocchi di linee con solo spazi
map ,Sbl :g/^\s*$/,/\S/-j
" raggruppa multipli Re:
map ,re 1G/^Subject: <CR>:s/\(Re: \)\+/Re: /e<CR>^M
" elimina i link dei gruppi yahoo
map ,delgyah :g#^>\? http://docs.yahoo#.-10,.d
" elimina tutti gli headers da una mail
map ,noheader :0,/^$/d
"
" --- MAIL END ---
"  
" --- PROGRAMMING ---
if has("autocmd")
    " some options for python files
    autocmd FileType python setlocal textwidth=0
    autocmd FileType python setlocal tabstop=4
    autocmd FileType python setlocal expandtab " spaces instead of tabs
    autocmd FileType python setlocal softtabstop=4 " treat 4 spaces as a tab
	" call pydoc with the name of the python module from which we want
	" help
	:command -nargs=+ Pyhelp :call ShowPydoc("<args>")
	function ShowPydoc(module, ...)
		let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
		execute ":!pydoc " . a:module . " > " . fPath
		execute ":sp " .fPath
	endfunction
    " some options for ruby files
    autocmd FileType ruby setlocal tabstop=2
    " nei file make non espandere tabs in spazi
    autocmd FileType make set noexpandtab shiftwidth=8
    " abilita function-complete per i file supportati
    autocmd BufNewFile *.html,.css,.htm set omnifunc=csscomplete#CompleteCSS
    autocmd BufRead *.html,.css,.htm set omnifunc=csscomplete#CompleteCSS
    autocmd BufNewFile *.py set omnifunc=pythoncomplete#Complete
    autocmd BufRead *.py set omnifunc=pythoncomplete#Complete
    " Max 78 characters for line in text files
    autocmd BufRead *.txt set tw=78
    " rende eseguibili tutti gli script
    autocmd BufWritePost * if getline(1) =~ "^#!/" | silent exe "!chmod u+x <afile>" | endif
    " aggiunge opzioni di vim all'ultima riga di ogni script (non funziona, scrive la riga di opzioni ogni volta che si salva il file)
    "autocmd BufWritePost * if getline(1) =~ "^#!/" && if getline($) =~ "^# vi" | silent :$s/^/# vim: set ft=sh tw=0:/ | endif
    " abilita l'editing dei file gzippati
    augroup gzip
	" prima elimina tutti i comandi già impostati
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
    " File ruby
    autocmd FileType ruby setlocal textwidth=80 
endif
"
" Funzioni per i commenti
function! ShellComment()
    map - :s/^/# /<CR>
    map _ :s/^\s*# \=//<CR>
    set comments=:#
endfunction

function! CComment()
    map - :s/^/\/\* /<CR>
    map _ :s/^\s*\/\* \=//<CR>
    set comments=:/*
endfunction
" ...e le vado ad attivare
if has("autocmd")
    autocmd FileType perl	call ShellComment()
    autocmd FileType cgi	call ShellComment()
    autocmd FileType sh		call ShellComment()
    autocmd FileType java	call ShellComment()
    autocmd FileType python	call ShellComment()
    autocmd FileType c,cpp	call CComment()
endif

" --- PROGRAMMING END ---
"
" --- HTML E XML ---
" opzione per xml.vim (rende i tag compatibili con xhtml)
let xml_use_xhtml=1	    
let xml_tag_completion_map = "<C-l>"
" use css for generated html files
let html_use_css=1

" --- Tex and Latex ---
"set grepprg=grep\ -nH\ $* " setting for vim-latex
"let g:Imap_DeleteEmptyPlaceHolders=1
"let g:Tex_DefaultTargetFormat="pdf"
"let g:Tex_ViewRule_dvi="evince"
"let g:Tex_ViewRule_ps="evince"
"let g:Tex_ViewRule_pdf="evince"
"let g:Tex_MultipleCompileFormats="dvi,pdf,ps"

" --- VARIOUS STUFF ---
"  tutto il testo su una linea con un solo spazio
map ,line  :%s/\n/ /g
" copio il contenuto di una sessione in un file temporaneo con "_Y e lo 
" importo in un'altra con "_P
nmap _Y :!echo ""> /tmp/.vi_tmp<CR><CR>:w! /tmp/.vi_tmp<CR>
vmap _Y :w! /tmp/.vi_tmp<CR>
nmap _P :r /tmp/.vi_tmp<CR>
" Tolgo il search highlighting quando mi muovo con il cursore
nmap j <Down>:nohls<CR>
nmap k <Up>:nohls<CR>
nmap h <Left>:nohls<CR>
nmap l <Right>:nohls<CR>
" Uso Ctrl+hjul per navigare quando in insert mode (Ctrl+h non va, uso u
" invece)
imap <C-u> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
imap <C-h> <Left>
"
" Uso due , in insert mode per uscire invece di Esc
imap ,, <Esc>
" Cambio il colore dell'highlighting per le parole non trovate nel
" dizionario (perchè cambiando i colori del terminale talvolta possono
" trovarsi combinazioni di difficile lettura)
" Altre opzioni che possono esser usate sono: SpellCap SpellRare e
" SpellLocal
hi SpellBad term=reverse ctermfg=white ctermbg=darkred guifg=#FFFFFF guibg=#7F0000 gui=underline

"Automaticamente chiedere la password quando si apre un file gpg con vim
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
"
" Apri il link nella linea corrente nel browser
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
