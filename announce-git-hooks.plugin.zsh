# Copyright Ned Batchelder
# Licensed under Creative Commons CC BY-NC-SA 4.0

git_show_hooks() {
    local git_dir=$(git rev-parse --absolute-git-dir 2>/dev/null)
    if [[ -z $git_dir ]]; then
        _git_shown_hooks_dir=
        return
    fi
    local hooks_dir=$(git rev-parse --git-path hooks)
    hooks_dir=${hooks_dir:a}
    # Only announce once per repo, not for every cd inside it.
    if [[ $hooks_dir == $_git_shown_hooks_dir ]]; then
        return
    fi
    _git_shown_hooks_dir=$hooks_dir

    local -a hooks
    local hook
    setopt localoptions nullglob
    for hook in $hooks_dir/*; do
        if [[ -f $hook && -x $hook && $hook != *.sample ]]; then
            hooks+=(${hook:t})
        fi
    done
    if (( $#hooks )); then
        echo -e "\e[31m\e[1mgit hooks active:\e[0m $hooks (from $git_dir)"
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd git_show_hooks
