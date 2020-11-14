# Austin Henley's custom zsh prompt.
# Features:
#   - Case insensitive autocomplete.
#   - Prompt indicates if in a git repo, if the repo is dirty, and the branch if non-master.
#   - A few aliases to save some keystrokes.

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# If a repo...
    # If current branch is not master...
        # Show branch in gray.
    # If repo is dirty...
        # Show red lambda.
    # Else...
        # Show green lambda.
# If not a repo...
    # Show white lambda.
function azhPrompt() {
    local output=""
    # If a repo...
    insideRepo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
    if [ "$insideRepo" ]; then
        # If current branch is not master...
        BRANCH=$(git rev-parse --abbrev-ref HEAD)
        if [[ "$BRANCH" != "master" && "$BRANCH" != "main" ]]; then
            output+="(%F{242}$BRANCH%f)"
        fi
        # If repo is dirty...
        if [[ $(git diff --stat) != '' ]]; then
            output+=" %F{red}λ"
        else
            output+=" %F{green}λ"
        fi
    else
        output+=" %F{242}λ"
    fi
    echo "$output"
}

setopt prompt_subst
PROMPT='[%F{cyan}%~%f]$(azhPrompt)%f '

alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias pwd='pwd -P'
alias gst='git status'
alias gaa='git add -A'
alias gp='git push'