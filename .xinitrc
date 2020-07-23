# Load SSH keys
eval "$(ssh-agent)"
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

#exec awesome 2>> ~/.xsession-errors
exec i3 2>> ~/.xsession-errors
