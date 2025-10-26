#!/usr/bin/env bash
set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'
DONE_TEXT="${GREEN}DONE ✓${RESET}"
FAIL_TEXT="${RED}FAIL ✗${RESET}"

# Associative array to record task status
declare -A task_status
# Indexed array to record task order
declare -a task_order

run_task() {
    local task_name="$1"
    local task_func="$2"

    echo "┌──────────────┐"
    echo "│ Running task │ $task_name"
    echo "└──────────────┘"
    task_order+=("$task_name")

    # Run the task in a subshell to isolate errors
    (
        set -e  # Exit immediately on failure *within this task only*
        $task_func
    )
    local status=$?

    echo
    if [[ $status -ne 0 ]]; then
        task_status_text="${FAIL_TEXT} $task_name (exit code $status)"
    else
        task_status_text="${DONE_TEXT} $task_name"
    fi
    echo -e "$task_status_text"
    task_status["$task_name"]="$task_status_text"
    echo
}


##################################################
# Define tasks
##################################################

install_apt_packages() {
    sudo apt update
    sudo apt install -y wget gpg i3 vim feh ripgrep ncal rofi lxappearance tree colordiff htop jq yq
}

copy_configs() {
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    sudo cp -a "$SCRIPT_DIR"/HOME/. "$HOME"
    sudo cp -a "$SCRIPT_DIR"/ROOT/. /
}

install_grub_customizer() {
    sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
    sudo apt update
    sudo apt install -y grub-customizer
}

install_wezterm() {
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    sudo apt update
    sudo apt install -y wezterm
}

install_spotify() {
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install -y spotify-client
}

install_vscode() {
    echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
    rm -f microsoft.gpg
    sudo apt install -y apt-transport-https
    sudo apt update
    sudo apt install -y code
}

install_fzf() {
    if [ ! -d "$HOME"/.fzf ]; then
        git clone -q --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
    fi
    "$HOME"/.fzf/install --key-bindings --completion --update-rc --no-zsh --no-fish
}

install_discord() {
    "$HOME"/.local/bin/update-discord.sh
}

set_darkmode() {
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

set_background() {
    # Creates `~/.fehbg` file for desktop background
    # i3 runs this file on startup to set the background
    feh --bg-scale "$HOME"/Pictures/wallpapers/digital-desat.jpg
}

backup_grub_config() {
    sudo cp /etc/default/grub /etc/default/grub.bak
}

install_sublime_text() {
    curl -s -L -o /tmp/sublimetext.deb https://download.sublimetext.com/sublime-text_build-3211_amd64.deb
    sudo apt install -y /tmp/sublimetext.deb
    sudo apt-mark hold sublime-text
}


##################################################
# Run tasks in order
##################################################
run_task "APT packages" install_apt_packages
run_task "Copy configs" copy_configs
run_task "fzf" install_fzf
run_task "VS Code" install_vscode
run_task "WezTerm" install_wezterm
run_task "Spotify" install_spotify
run_task "Discord" install_discord
run_task "Set prefer-dark" set_darkmode
run_task "Set background image" set_background
run_task "Backup GRUB config" backup_grub_config
run_task "Grub Customizer" install_grub_customizer
run_task "Sublime Text 3" install_sublime_text


echo "┌─────────┐"
echo "│ Summary │"
echo "└─────────┘"
for name in "${task_order[@]}"; do
    echo -e "${task_status[$name]}"
done
