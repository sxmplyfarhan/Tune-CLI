# 🎵 Tune-CLI

Tune-CLI (command `tune`) is a lightweight **terminal music player** for Linux, macOS, and Windows.  
It lets you play local music files (`.mp3`, `.webm`, `.mp4`) directly in the terminal with colorful, interactive controls.  

---

# ⚡ Features

- Play local music files: `.mp3`, `.webm`, `.mp4`
- Pause/Play, Next, Previous, Seek
- Shuffle and Repeat modes
- Default folder management
- Interactive terminal UI with progress bars and colors
- Works cross-platform: Linux, macOS, Windows

---

## 📦 Requirements

**Core dependencies:**
- Python 3.6+
- mpv
- ffmpeg
- python-mutagen

**Platform specifics:**
- Debian/Ubuntu → `apt install mpv ffmpeg python3-mutagen`
- Fedora → `dnf install mpv ffmpeg python3-mutagen`
- Arch/Manjaro → `pacman -S mpv ffmpeg python-mutagen`
- Void Linux → `xbps-install -S mpv ffmpeg python-mutagen`
- NixOS → `nix-env -iA nixpkgs.mpv nixpkgs.ffmpeg nixpkgs.python3Packages.mutagen`
- macOS → `brew install mpv ffmpeg python-mutagen`
- Windows → Install mpv, ffmpeg, Python, mutagen via pip: `pip install mutagen`

---

## ⚡ Installation

```bash
# Git clone the repository
git clone https://github.com/sxmplyfarhan/Tune-CLI.git

# Go into the cloned repository
cd Tune-CLI

# Make the installer executable
chmod +x install.sh

# Run the installer (asks for sudo if needed)
./install.sh
The installer will:
Pull the latest version from GitHub
Install necessary dependencies
Make tune globally executable
Display a usage guide after installation
Updating: Just run the installer again:
sudo ./install.sh
Usage
# Show help
tune -h

# Set default music folder
tune set default ~/Music

# Play music
tune play
Player Controls (while playing)
Key	Action
p	Pause/Play
n / ↓	Next track
b / ↑	Previous track
← / →	Seek backward/forward
r	Repeat mode (None / All / Track)
s	Shuffle
q / ESC	Quit
Supported Platforms
Linux: Arch, Debian/Ubuntu, Fedora, Void, Alpine, OpenSUSE, Gentoo, NixOS
macOS: via Homebrew
Windows: manual installation or use a terminal with mpv & ffmpeg installed
Contributing
Feel free to fork and modify for personal use.
Do not sell or redistribute the software.
Pull requests, bug reports, and suggestions are welcome!
License
Custom Non-Commercial, No Distribution License (NC-ND)
Tune-CLI is provided "as-is". You are free to:

- Use it personally.
- Modify the code for personal projects.

You MAY NOT:

- Sell this software or derivatives.
- Redistribute or upload this software publicly.

You MUST:

- Include this license in any personal modifications.
Thanks
Made with ❤️ by Farhan. Enjoy your music!

```
