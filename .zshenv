typeset -U PATH path
path=("$HOME/.local/bin" "/usr/local/bin/" "/usr/lib/go/bin/" "$HOME/.go/bin/" "$path[@]")
export PATH
# No mail checker pls
export MAILCHECK=0
