syntax on
"color bclear
color twilight256
" Set window's size
au GUIEnter * set lines=56 columns=100

" maps for using Ctrl+c for copying and Ctrl+v for pasting (as in win
" and as with the macro for the lachesis)
vmap <C-C> "+y
imap <C-C> "+y

"nm \\paste\\ "=@*.'xy'<CR>gPFx"_2x:echo<CR>
"imap <C-V> x<Esc>\\paste\\"_s
"vmap <C-V> "-cx<Esc>\\paste\\"_x

vmap <C-V> "+gP<CR>
imap <C-V> <Esc>"+gP<Esc>
