#!/usr/bin/env bash

# =========================
# Magenta + Red Installer / Updater for tune-
# =========================

REPO="https://github.com/sxmplyfarhan/Tune-CLI.git"
PLAYER_NAME="tune"
PLAYER_SCRIPT="$PWD/tune"   # your local file
INSTALL_PATH="/usr/local/bin/$PLAYER_NAME"
TMP_DIR="/tmp/tune-install"

# Color codes
RED='\033[1;31m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

echo -e "${MAGENTA}✨ Welcome to the ${PLAYER_NAME} installer/updater!${NC}"

# Prompt for sudo upfront
echo -e "${MAGENTA}⚡ Some actions require sudo privileges.${NC}"
sudo -v || { echo -e "${RED}❌ Failed to authenticate sudo.${NC}"; exit 1; }

# Pull latest from GitHub
echo -e "${MAGENTA}📡 Pulling latest version from GitHub...${NC}"
rm -rf "$TMP_DIR"
git clone --depth=1 "$REPO" "$TMP_DIR" || { echo -e "${RED}❌ Failed to clone repository.${NC}"; exit 1; }

# Use the latest script
PLAYER_SCRIPT="$TMP_DIR/tune"

# Detect distro and install dependencies
install_deps() {
    if command -v pacman &> /dev/null; then
        echo -e "${MAGENTA}Detected Arch-based system.${NC}"
        echo -e "${MAGENTA}Installing dependencies: mpv, ffmpeg, python-mutagen...${NC}"
        sudo pacman -Sy --noconfirm mpv ffmpeg python-mutagen || { echo -e "${RED}❌ Failed to install dependencies.${NC}"; exit 1; }
    elif command -v apt &> /dev/null; then
        echo -e "${MAGENTA}Detected Debian/Ubuntu system.${NC}"
        echo -e "${MAGENTA}Updating package list...${NC}"
        sudo apt update
        echo -e "${MAGENTA}Installing dependencies: mpv, ffmpeg, python3-mutagen...${NC}"
        sudo apt install -y mpv ffmpeg python3-mutagen || { echo -e "${RED}❌ Failed to install dependencies.${NC}"; exit 1; }
    elif command -v dnf &> /dev/null; then
        echo -e "${MAGENTA}Detected Fedora system.${NC}"
        echo -e "${MAGENTA}Installing dependencies: mpv, ffmpeg, python3-mutagen...${NC}"
        sudo dnf install -y mpv ffmpeg python3-mutagen || { echo -e "${RED}❌ Failed to install dependencies.${NC}"; exit 1; }
    else
        echo -e "${RED}❌ Unsupported Linux distro!${NC}"
        echo -e "${MAGENTA}Please install mpv, ffmpeg, and python-mutagen manually.${NC}"
        exit 1
    fi
}

# Install or update the player
install_player() {
    if [[ -f "$INSTALL_PATH" ]]; then
        echo -e "${MAGENTA}Updating existing ${PLAYER_NAME}...${NC}"
    else
        echo -e "${MAGENTA}Installing ${PLAYER_NAME} for the first time...${NC}"
    fi

    if [[ -f "$PLAYER_SCRIPT" ]]; then
        chmod +x "$PLAYER_SCRIPT"
        sudo cp "$PLAYER_SCRIPT" "$INSTALL_PATH"
        sudo chmod +x "$INSTALL_PATH"
        echo -e "${MAGENTA}✅ ${PLAYER_NAME} is now installed/updated at ${INSTALL_PATH}${NC}"
    else
        echo -e "${RED}❌ Player script not found at ${PLAYER_SCRIPT}${NC}"
        exit 1
    fi
}

# Print a mini-guide
print_guide() {
    echo -e "\n${MAGENTA}🎵 ${PLAYER_NAME} Guide:${NC}"
    echo -e "${MAGENTA}-----------------------------------${NC}"
    echo -e "${RED}Run your player:${NC} tune-"
    echo -e "${RED}Controls:${NC}"
    echo -e "  p       Pause/Play"
    echo -e "  n / ↓   Next track"
    echo -e "  b / ↑   Previous track"
    echo -e "  ← / →   Seek backward/forward"
    echo -e "  r       Repeat mode (None / All / Track)"
    echo -e "  s       Shuffle"
    echo -e "  q / ESC Quit"
    echo -e "${RED}Default music folder:${NC} ~/.play_default_dir"
    echo -e "${MAGENTA}-----------------------------------${NC}"
    echo -e "${MAGENTA}Enjoy your music! 🎵${NC}"
}

# Execute
install_deps
install_player
print_guide

# Clean up
rm -rf "$TMP_DIR"


