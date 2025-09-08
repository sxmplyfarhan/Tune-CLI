#!/usr/bin/env bash

# =========================
# Magenta + Red Installer for tune-
# =========================

PLAYER_NAME="tune-"
PLAYER_SCRIPT="$PWD/play.py"   # change if your Python file is named differently
INSTALL_PATH="/usr/local/bin/$PLAYER_NAME"

# Color codes
RED='\033[1;31m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

echo -e "${MAGENTA}✨ Installing ${PLAYER_NAME}...${NC}"

# Root check
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}⚠️  This script requires sudo privileges!${NC}"
    echo -e "${MAGENTA}Run with: sudo $0${NC}"
    exit 1
fi

# Detect distro and install dependencies
if command -v pacman &> /dev/null; then
    echo -e "${MAGENTA}Detected Arch-based system.${NC}"
    echo -e "${MAGENTA}Installing dependencies: mpv, ffmpeg, python-mutagen...${NC}"
    pacman -Sy --noconfirm mpv ffmpeg python-mutagen || { echo -e "${RED}❌ Failed to install dependencies.${NC}"; exit 1; }
elif command -v apt &> /dev/null; then
    echo -e "${MAGENTA}Detected Debian/Ubuntu system.${NC}"
    echo -e "${MAGENTA}Updating package list...${NC}"
    apt update
    echo -e "${MAGENTA}Installing dependencies: mpv, ffmpeg, python3-mutagen...${NC}"
    apt install -y mpv ffmpeg python3-mutagen || { echo -e "${RED}❌ Failed to install dependencies.${NC}"; exit 1; }
elif command -v dnf &> /dev/null; then
    echo -e "${MAGENTA}Detected Fedora system.${NC}"
    echo -e "${MAGENTA}Installing dependencies: mpv, ffmpeg, python3-mutagen...${NC}"
    dnf install -y mpv ffmpeg python3-mutagen || { echo -e "${RED}❌ Failed to install dependencies.${NC}"; exit 1; }
else
    echo -e "${RED}❌ Unsupported Linux distro!${NC}"
    echo -e "${MAGENTA}Please install mpv, ffmpeg, and python-mutagen manually.${NC}"
    exit 1
fi

# Install the player
if [[ -f "$PLAYER_SCRIPT" ]]; then
    echo -e "${MAGENTA}Copying script to /usr/local/bin...${NC}"
    chmod +x "$PLAYER_SCRIPT"
    cp "$PLAYER_SCRIPT" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"
    echo -e "${MAGENTA}✅ ${PLAYER_NAME} installed successfully to ${INSTALL_PATH}!${NC}"
else
    echo -e "${RED}❌ Player script not found at ${PLAYER_SCRIPT}${NC}"
    exit 1
fi

echo -e "${MAGENTA}You can now run your player with: ${RED}${PLAYER_NAME}${NC}"
echo -e "${MAGENTA}Enjoy your music! 🎵${NC}"
