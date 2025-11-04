alias ls='ls -lFh --group-directories-first --color=auto --time-style="+%Y-%m-%d %H:%M:%S"'
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias mkdir="mkdir -pv"
alias tree="tree -C"
alias diff="colordiff"
alias tsnow="date +%s"
alias cal="ncal -b -A 1 -B 1"
alias bc="bc -l"
alias gs="git status"
ts() {
    local input="$1"

    if [ ${#input} -gt 10 ]; then
        input=${input:0:10}
        echo "Truncating to: ${input}"
    fi

    date -d@"${input:0:10}"
}
dpms_delay() {
    local delay="$1"

    if [ -z "$delay" ]; then
        echo "Requires input in seconds"
        return 1
    fi

    xset dpms "$delay" "$delay" "$delay" && echo "DPMS delay: ${delay}s"
}
alias zzz="dpms_delay 10"
alias wake="dpms_delay 3600"
