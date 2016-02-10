for file in ~/.{extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LS_COLORS="$LS_COLORS:di=33:*.js=92"

# Navigation
alias ..="cd .."
alias ~="cd ~"
alias l="gls -l -h --color --group-directories-first"
alias la="gls -la -h --color --group-directories-first"
alias s="cd ~/Scratch"
alias a="atom ."

# Go to Git repository root
alias gr='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
alias gs="git status"
alias ga="git add -A"

# Use GNU df
alias df="gdf"

# Get git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ on \1/'
}

set_prompts() {
    local black=$(tput setaf 0)
    local blue=$(tput setaf 33)
    local bold=$(tput bold)
    local teal=$(tput setaf 37)
    local cyan=$(tput setaf 123)
    local green=$(tput setaf 64)
    local lime=$(tput setaf 112)
    local carrot=$(tput setaf 166)
    local orange=$(tput setaf 136)
    local purple=$(tput setaf 125)
    local red=$(tput setaf 124)
    local reset=$(tput sgr0)
    local gray=$(tput setaf 8)
    local white=$(tput setaf 2)
    local yellow=$(tput setaf 184)

    tput sgr0 # reset colors

    # set the terminal title to the current working directory
    PS1="\n" # newline
    PS1+="\[$lime\]\W" # working directory
    PS1+="\[$teal\]\$(parse_git_branch)"
    PS1+="\[$yellow\] \$ \[$reset\]"

    export PS1
}

set_prompts
unset set_prompts

# Add tab completion for Git commands and branches
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
