#!/bin/zsh
# OH-my-zsh is too much, but the prompt is nice
# The following are extracted from oh-my-zsh/lib/git.zsh and modified somewhat

ZSH_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg[green]%}✓"

# TODO: Right prompt: Other environments? Project? Case?

# Checks if working tree is dirty
function parse_git_dirty() {
    local STATUS
    STATUS=$(command git status --porcelain --ignore-submodules=dirty --untracked-files=no 2> /dev/null | tail -n1)
    if [[ -n $STATUS ]]; then
        echo "$ZSH_GIT_PROMPT_DIRTY"
    else
        echo "$ZSH_GIT_PROMPT_CLEAN"
    fi
}

# Outputs current branch info in prompt format
function prompt_git_info() {
    local ref
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_GIT_PROMPT_SUFFIX"
    # echo "$ZSH_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_GIT_PROMPT_SUFFIX"
}

# Outpts environment information very succinctly
function right_prompt() {
    local rprompt
    # rprompt=" %*"
    # Show python version if explicitly set with pyenv
    localver=$(command pyenv local 2> /dev/null) || return 0
    rprompt=" $localver"
    # venv or not
    if [[ -n "$VIRTUAL_ENV" ]]; then
        rprompt="∇$rprompt"
    fi
    # tmux shell?
    if [ -n "$TMUX_PANE" ]; then
        rprompt="™$rprompt"
    fi
    # Ranger spawned shell
    if [ -n "$RANGER_LEVEL" ]; then
        rprompt="Υ$rprompt"
    fi
    echo "$rprompt"
}

# Some digraphs I went through
# V?=Ṽ, 7a=۷, n*=ν, v3=ѵ, u*=υ, u3=ΰ, V3=Ѵ, u%=ύ, Tj=ט, NB=∇, +Z=∑, ;_=〆,
# R,=Ŗ, R<=Ř, yr=Ʀ, R'=Ŕ, ja=я, U*=Υ, JA=Я, R_=Ṟ, Rx=℞, R.=Ṙ,
# T,=Ţ, T<=Ť, T*=Τ, TM=™
