#!/bin/zsh
# OH-my-zsh is too much, but the prompt is nice
# The following are extracted from oh-my-zsh/lib/git.zsh and modified somewhat

ZSH_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg[green]%}✓"

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
    echo "$ZSH_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_GIT_PROMPT_SUFFIX"
}

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

