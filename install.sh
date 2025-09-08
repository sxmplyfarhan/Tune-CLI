#!/usr/bin/env bash

RED="\033[1;31m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${MAGENTA}✨ Welcome to the Tune installer/updater!${RESET}"

# Detect Linux distro
OS=""
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

echo -e "${MAGENTA}Detected OS: $OS${RESET}"

# Require sudo for Linux systems (except NixOS)
if [[ "$OS" != "nixos" ]]; then
    sudo -v || { echo -e "${RED}Cannot continue without sudo!${RESET}"; exit 1; }
fi

# Pull latest version from GitHub
TMPDIR=$(mktemp -d)
echo -e "${MAGENTA}📡 Pulling latest version from GitHub...${RESET}"
git clone https://github.com/sxmplyfarhan/Tune-CLI.git "$TMPDIR" >/dev/null 2>&1 || { echo -e "${RED}Failed to clone repo.${RESET}"; exit 1; }

# Install dependencies
echo -e "${MAGENTA}⚙️ Installing dependencies...${RESET}"

case "$OS" in
    arch) sudo pacman -S --needed mpv ffmpeg python-mutagen --noconfirm >/dev/null 2>&1 ;;
    debian) sudo apt update -qq >/dev/null 2>&1; sudo apt install -y mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    fedora) sudo dnf install -y mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    void) sudo xbps-install -Sy mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    alpine) sudo apk add mpv ffmpeg py3-mutagen >/dev/null 2>&1 ;;
    opensuse) sudo zypper install -y mpv ffmpeg python3-mutagen >/dev/null 2>&1 ;;
    gentoo) sudo emerge --ask media-sound/mpv media-video/ffmpeg dev-python/mutagen >/dev/null 2>&1 ;;
    nixos) echo -e "${RED}⚠️  Make sure mpv, ffmpeg, python3Packages.mutagen are in your nix profile${RESET}" ;;
    *) echo -e "${RED}Unsupported Linux distro. Install dependencies manually.${RESET}" ;;
esac

echo -e "${MAGENTA}✅ Dependencies installed!${RESET}"

# Install/update Tune
echo -e "${MAGENTA}🚀 Installing/updating Tune...${RESET}"
sudo cp "$TMPDIR/tune" /usr/local/bin/tune
sudo chmod +x /usr/local/bin/tune
echo -e "${MAGENTA}✅ Tune installed/updated at /usr/local/bin/tune${RESET}"

# Clean up
rm -rf "$TMPDIR"

# Show guide
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
echo -e "${MAGENTA}Enjoy your music! 🎵${RESET}"
