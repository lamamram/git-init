alias gst='git status'
__git_complete gst _git_status
alias gci='git commit'
__git_complete gci _git_commit
alias gco='git checkout'
__git_complete gco _git_checkout
alias gadd='git add .'
alias push='git push'
__git_complete push _git_push
alias pull='git pull'
__git_complete pull _git_pull
alias fetch='git fetch'
__git_complete fetch _git_fetch
alias gbr='git branch'
__git_complete gbr _git_branch
# alias gsw='auto-stash.sh'
# __git_complete gsw _git_switch


function ac {
  if [ 1 -ne $# ]; then
	  echo "bad message !"
	else
	  gadd && gci -m "$1"
	fi
}


function acp {
	if [ 1 -ne $# ]; then
	  echo "bad message !"
	else
	  ac "$1" && push
	fi
}