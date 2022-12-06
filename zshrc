# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Add Golang to path
export PATH="$PATH:$(go env GOPATH)/bin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Add reco scripts to PATH
export PATH="$PATH:$HOME/devel/reco/scripts"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    terraform
    zsh-autosuggestions
    virtualenv
    poetry
    fzf
    kubectl
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Ignore Delete Ctrl+D for closing the terminal
setopt ignore_eof

# TheFuck
eval $(thefuck --alias)

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

### git alias
alias gst='git status'
alias gt='git log --graph --abbrev-commit --decorate --date=relative --all -n10 --oneline'
alias gll="git --no-pager log -n 17 --abbrev-commit --decorate --date=short --format=tformat:'%Cgreen%h %C(yellow)%an%x09 %C(blue)%ad%Creset %C(red)%d%Creset %C(white)%s%Creset'"
alias gwc='git whatchanged'
alias gka='gitk --all'
alias gru='git remote update origin'
alias gft='git fetch -t --all'
alias grv='git remote -v'
alias gsb='git show-branch --topo-order'
alias gsw='git show -W'
alias gswn='git show -W --name-only'
alias gbr='git branch -v'
alias gco='git checkout'

alias gitadd='git ls-files --modified | xargs git add '
alias gai='git add --interactive'
alias gap='git add --patch'
alias grs='git restore'
alias grss='git restore --staged'
alias gcv='git commit --signoff -v'
alias gca='git commit --signoff --amend -C HEAD $*'

alias gsl='git stash list'
alias gss='git stash show -p'
alias gtl='git tag --list'

alias gri='git rebase --interactive'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gmt='git mergetool -t meld'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'

alias gds='git diff --cached'	# gds == "git diff, STAGED changes" 
alias gdu='git diff'		# gdu == "git diff, UNSTAGED changes" 
alias gda='git diff HEAD'	# gda == "git diff, ALL changes, stages & unstaged" 
alias gdl='git diff HEAD^'	# gdl == "git diff, ALL changes since last commit"
alias gdt='git difftool'	# gdu == "git diff, UNSTAGED changes" 
alias gdh='git difftool HEAD^'	# gdl == "git diff, ALL changes since last commit"

alias gsn='git diff-index --cached --name-only HEAD'     # gss == "git status, STAGED files" 
alias gsu='git ls-files --exclude-standard --modified'   # gsu == "git status, UNSTAGED files" 
alias gso='git ls-files --exclude-standard --other'      # gso == "git status, OTHER  (i.e. untracked) files"
alias glg='git log --oneline --decorate --graph --all'

alias tg='tig status'
alias nivlog='git log --all --decorate --oneline --graph'


gtp() { git tag "$1" --force && git push origin "$1" --force ; }


# some more ls aliases
alias ll='ls -ltrh'
alias la='ls -altrh'
alias l='ls -CF'

# general aliases

# TODO: fzf priview in ctrl+r search mode
# fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'



alias brewi='HOMEBREW_NO_AUTO_UPDATE=1 brew install'
alias rg='grep -Rn --include="*.[gp][oy]" '
alias ry='grep -Rn --include="*.yml" --include="*.yaml" '
alias grepgo='find ../ -name "*.go*" -not -path "*vendor*" -exec grep -rniH mockery {} \;'

alias gnir='egrep -Inir'
alias pstree='pstree -Aapn'
alias vi='vim'
alias vi2='vim -O2'
alias c='clear'
alias cd..='cd ..'

alias dprune='docker system prune --all --filter "until=72h"'
#k logs $(k get pod -l app.kubernetes.io/instance=backend-gateway.blue -n blue -o name) -n blue


# lintest aliases
alias mypyt='poetry run mypy . --config-file=mypy.ini'
alias f8t='poetry run flake8 . --config .flake8 --max-line-length 160'
alias pyt='f8t && mypyt'
alias prp='poetry run pytest'

alias gol='golangci-lint run -v --print-resources-usage --modules-download-mode=readonly --timeout=10m'
alias gob='go build -mod=readonly -o=./app && rm ./app && echo "Build success"'
alias gmvt='go mod vendor && go mod tidy'
alias got='gmvt && gol && go test ./... -v && gob && echo "🎉 GREAT SUCCESS 🎉"'

# location aliases
alias ec2b='ssh -i "~/ec2.pem" ubuntu@10.0.78.185 -t tmux attach -t nate-dont-touch'
alias cdr='cd $HOME/devel/reco/src'
alias cdr2='cd $HOME/devel/reco2/src'
alias cdu='cd $HOME/devel/reco/src/reco-ui'
alias cdi='cd $HOME/devel/recolabs-infra'
alias cdgo='cd $HOME/devel/go'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(pyenv virtualenv-init -)"

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh kubectl auto completion
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

# Java versions
javahome() {
  unset JAVA_HOME
  export JAVA_HOME=$(/usr/libexec/java_home -v "$1");
  java -version
}
alias j11='javahome 11'
alias j17='javahome 17'

CERT_PATH=$(python -m certifi)
export SSL_CERT_FILE=${CERT_PATH}
export REQUESTS_CA_BUNDLE=${CERT_PATH}


#export PATH="$HOME/.poetry/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
