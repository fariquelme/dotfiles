#========= Configs
#----- Zoxide
eval "$(zoxide init zsh)"

#----- Pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

#----- Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#----- Disable auto-update of Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

#----- Prompt
# Config for the prompt. PS1 synonym.
zstyle ':vcs_info:*' enable git svn
# This line obtains information from the vcs.
zstyle ':vcs_info:git*' formats "%b"
precmd() {
    vcs_info
    PYENV_PROMPT=''
    local version
    version=''
    if [[ -n $PYENV_VIRTUAL_ENV ]]; then
            version=${(@)$(pyenv version)[1]}
            PYENV_PROMPT=$version
    fi
}

# Enable substitution in the prompt.
prompt='%b%F{#23ff8d}█%F{#000}%K{#23ff8d}%2~%k%F{#23ff8d}█ %F{green}${PYENV_PROMPT} %F{yellow}${vcs_info_msg_0_}
%}%B%F{#80a0ff}●%F{#23ff8d}❱ %b%f%k'
setopt prompt_subst

#========= Increase history size
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=99999999999999999
SAVEHIST=99999999999999999
HISTFILE=~/.zsh_history

#========= Aliases
#----- ls
alias ls='ls -G --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -lA --color=auto'
alias ls='ls -G --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -lA --color=auto'
#----- Nvim
alias vi=nvim
alias vim=nvim
#----- Python
alias pip='python -m pip'
alias popy='poetry run python -m'
#----- Git
alias tree='tree --dirsfirst'
alias gtree='git log --graph --full-history --all --color --pretty=format:"%x1b[33m%h%x09%x09%x1b[32m%d%x1b[0m %x1b[34m%an%x1b[0m   %s" "$@"'
#----- git better log
#git config --global alias.glog "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
#git config --global alias.clog "log --pretty='%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s %C(auto)%d' --date=short --decorate"
#----- Others
alias grep='grep --color'
alias mactop='sudo /opt/homebrew/bin/mactop'
alias mtop='sudo /opt/homebrew/bin/mactop'
