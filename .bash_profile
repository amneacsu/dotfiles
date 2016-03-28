for file in ~/.{extra,aliases}; do
    [ -r "$file" ] && source "$file"
done
unset file

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LS_COLORS="$LS_COLORS:di=38;5;220;1:*.js=92"

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


    ## early exit for Chromium & Blink repo, as the dirty check takes ~5s
    ## also recommended (via goo.gl/wAVZLa ) : sudo sysctl kern.maxvnodes=$((512*1024))
    repoUrl=$(git config --get remote.origin.url)
    if grep -q chromium.googlesource.com <<<$repoUrl; then
        dirty=" ⁂"
    else

        # check if it's dirty (slow)
        #   technique via github.com/git/git/blob/355d4e173/contrib/completion/git-prompt.sh#L472-L475
        dirty=$(git diff --no-ext-diff --quiet --ignore-submodules --exit-code || echo -e "*")

        # mathias has a few more checks some may like:
        #    github.com/mathiasbynens/dotfiles/blob/a8bd0d4300/.bash_prompt#L30-L43
    fi


    [ -n "${s}" ] && s=" [${s}]";
    echo -e "${1}${branchName}${2}$dirty";

    return
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
    local gold=$(tput setaf 220)

    tput sgr0 # reset colors

    PS1="\[$gold\]\W"
    PS1+="\$(prompt_git \"\[$white\] on \[$teal\]\" \"\[$red\]\")"
    PS1+="\[$yellow\] \$ \[$reset\]"

    export PS1
}

set_prompts
unset set_prompts

# Add tab completion for Git commands and branches
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi
