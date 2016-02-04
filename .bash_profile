for file in ~/.{extra,bash_profile}; do
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
    tput sgr0 # reset colors

    reset=$(tput sgr0)

    cyan=$(tput setaf 123)
    carrot=$(tput setaf 166)
    lime=$(tput setaf 112)
    orange=$(tput setaf 136)
    yellow=$(tput setaf 184)

    PS1="\n"
    PS1+="\[$lime\]\W" # working directory
    PS1+="\[$cyan\]\$(parse_git_branch)" # current git branch
    PS1+="\[$yellow\] $ \[$reset\]" # plata

    export PS1
}

set_prompts
unset set_prompts

# Add tab completion for Git commands and branches
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
