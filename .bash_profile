for file in ~/.{extra,aliases}; do
    [ -r "$file" ] && source "$file"
done
unset file

export BASH_SILENCE_DEPRECATION_WARNING=1
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LS_COLORS="$LS_COLORS:di=38;5;201;1:ex=38;5;51;1"
export HOMEBREW_NO_ANALYTICS=1

# Navigation
alias ..="cd .."
alias ~="cd ~"
alias l="gls -l -h --color --group-directories-first"
alias la="gls -la -h --color --group-directories-first"
alias s="cd ~/Scratch"
alias cmus="cmus --show-cursor $@ 2>/dev/null"
alias a="atom ."

# Go to Git repository root
alias g="git"
alias gr='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
alias gs="git status"
alias ga="git add -A"

# Use GNU df
alias df="gdf"

function prompt_git() {
    # this is >5x faster than mathias's.

    # check if we're in a git repo. (fast)
    git rev-parse --is-inside-work-tree &>/dev/null || return

    # check for what branch we're on. (fast)
    #   if… HEAD isn’t a symbolic ref (typical branch),
    #   then… get a tracking remote branch or tag
    #   otherwise… get the short SHA for the latest commit
    #   lastly just give up.
    branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
        git describe --all --exact-match HEAD 2> /dev/null || \
        git rev-parse --short HEAD 2> /dev/null || \
        echo '(unknown)')";

    # check if it's dirty (slow)
    #   technique via github.com/git/git/blob/355d4e173/contrib/completion/git-prompt.sh#L472-L475
    dirty=$(git diff --no-ext-diff --quiet --ignore-submodules --exit-code || echo -e "*")

    # mathias has a few more checks some may like:
    #    github.com/mathiasbynens/dotfiles/blob/a8bd0d4300/.bash_prompt#L30-L43


    [ -n "${s}" ] && s=" [${s}]";
    echo -e "${1}${branchName}${2}$dirty";

    return
}

set_prompts() {
    local black=$(tput setaf 0)
    local blue=$(tput setaf 33)
    local bold=$(tput bold)
    local teal=$(tput setaf 37)
    local cyan=$(tput setaf 51)
    local green=$(tput setaf 64)
    local lime=$(tput setaf 112)
    local carrot=$(tput setaf 166)
    local orange=$(tput setaf 136)
    local purple=$(tput setaf 125)
    local red=$(tput setaf 124)
    local reset=$(tput sgr0)
    local gray=$(tput setaf 8)
    local white=$(tput setaf 15)
    local yellow=$(tput setaf 184)
    local magenta=$(tput setaf 201)
    local gold=$(tput setaf 220)

    tput sgr0 # reset colors

    PS1="\[$magenta\]\W"
    PS1+="\$(prompt_git \"\[$white\] on \[$cyan\]\" \"\[$magenta\]\")"
    PS1+="\[$white\] \$ \[$reset\]"

    export PS1
}

# Check whether the shell is an interactive shell
if [[ $- == *i* ]]; then
  set_prompts
fi
unset set_prompts

# Add tab completion for Git commands and branches
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
. `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi
