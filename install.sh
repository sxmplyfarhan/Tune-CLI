#!/usr/bin/env bash


RED="\033[1;31m"
MAGENTA="\033[1;35m"
CYAN="\033[1;31m"
GREEN="\033[1;31m"
YELLOW="\033[1;31m"
RESET="\033[0m"

echo -e "${MAGENTA}✨ Welcome to the Tune installer/updater!${RESET}"


OS=""
UNAME=$(uname)
case "$UNAME" in
    Linux*)
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                arch|manjaro) OS="arch" ;;
                ubuntu|debian|pop) OS="debian" ;;
                fedora) OS="fedora" ;;
                void) OS="void" ;;
                alpine) OS="alpine" ;;
                opensuse*|suse) OS="opensuse" ;;
                gentoo) OS="gentoo" ;;
                nixos) OS="nixos" ;;
                *) OS="linux-unknown" ;;
            esac
        fi
        ;;
    Darwin*) OS="macos" ;;
    MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
    *) OS="unknown" ;;
esac

echo -e "${CYAN}Detected OS: $OS${RESET}"

if [[ "$OS" != "windows" && "$OS" != "nixos" ]]; then
    sudo -v || { echo -e "${RED}Cannot continue without sudo!${RESET}"; exit 1; }
fi

TMPDIR=$(mktemp -d)
echo -e "${CYAN}📡 Pulling latest version from GitHub...${RESET}"
git clone https://github.com/sxmplyfarhan/Tune-CLI.git "$TMPDIR" >/dev/null 2>&1 || { echo -e "${RED}Failed to clone repo.${RESET}"; exit 1; }


echo -e "${CYAN}⚙️ Installing dependencies...${RESET}"

case "$OS" in
    arch) sudo pacman -S --needed mpv ffmpeg python-mutagen --noconfirm >/dev/null 2>&1 ;;
    debian) sudo apt update -qq >/dev/null 2>&1; sudo apt install -y mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    fedora) sudo dnf install -y mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    void) sudo xbps-install -Sy mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    alpine) sudo apk add mpv ffmpeg py3-mutagen >/dev/null 2>&1 ;;
    opensuse) sudo zypper install -y mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    gentoo) sudo emerge --ask media-sound/mpv media-video/ffmpeg dev-python/mutagen >/dev/null 2>&1 ;;
    nixos) echo -e "${YELLOW}⚠️  Make sure mpv, ffmpeg, python3Packages.mutagen are in your nix profile${RESET}" ;;
    macos)
        if ! command -v brew >/dev/null 2>&1; then
            echo -e "${RED}Homebrew not found. Install it first: https://brew.sh/${RESET}"
        else
            brew install mpv ffmpeg python-mutagen >/dev/null 2>&1
        fi
        ;;
    windows)
        if command -v winget >/dev/null 2>&1; then
            winget install --id=MPV.MPV -e --silent
            winget install --id=FFmpeg.FFmpeg -e --silent
            python -m pip install mutagen
        else
            echo -e "${YELLOW}⚠️  Please install mpv, ffmpeg, and mutagen manually.${RESET}"
        fi
        ;;
    *)
        echo -e "${RED}Unsupported OS. Install dependencies manually.${RESET}" ;;
esac

echo -e "${GREEN}✅ Dependencies installed!${RESET}"


echo -e "${CYAN}🚀 Installing/updating Tune...${RESET}"

if [[ "$OS" == "windows" ]]; then
    DEST="$HOME/AppData/Local/Programs/tune"
    mkdir -p "$DEST"
    cp "$TMPDIR/tune" "$DEST/tune.py"
    echo -e "${GREEN}✅ Tune installed at $DEST/tune.py${RESET}"
else
    sudo cp "$TMPDIR/tune" /usr/local/bin/tune
    sudo chmod +x /usr/local/bin/tune
    echo -e "${GREEN}✅ Tune installed/updated at /usr/local/bin/tune${RESET}"
fi

rm -rf "$TMPDIR"


echo -e "\n${MAGENTA}🎵 Tune Guide:${RESET}"
echo "-----------------------------------"
echo "Run your player: tune play"
echo "Commands:"
echo "  tune play                  Start playing music"
echo "  tune set default <folder>  Set default music folder"
echo "  tune -h                    Show this help"
echo ""
echo "Player Controls (when running 'tune play'):"
echo "  p       Pause/Play"
echo "  n / ↓   Next track"
echo "  b / ↑   Previous track"
echo "  ← / →   Seek backward/forward"
echo "  r       Repeat mode (None / All / Track)"
echo "  s       Shuffle"
echo "  q / ESC Quit"
echo "Default music folder: ~/.play_default_dir"
echo "-----------------------------------"
echo -e "${GREEN}Enjoy your music! 🎵${RESET}"
