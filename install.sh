#!/bin/bash

# --- Configuration ---
REPO_URL="https://github.com/aeroslayys/lemon-niri-installer"
WALLPAPER_URL="https://github.com/JaKooLit/Wallpaper-Bank"
DOTFILES_DIR="$HOME/lemon-niri-installer"
WALLPAPER_DIR="$HOME/Pictures/Wallpaper-Bank"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

# --- Banner ---
show_banner() {
    clear
    echo -e "${YELLOW}"
    cat << "EOF"
  _      ______ __  __  ____  _   _ 
 | |    |  ____|  \/  |/ __ \| \ | |
 | |    | |__  | \  / | |  | |  \| |
 | |    |  __| | |\/| | |  | | . ` |
 | |____| |____| |  | | |__| | |\  |
 |______|______|_|  |_|\____/|_| \_|
      --- LEMON NIRI INSTALLER ---
EOF
    echo -e "${NC}"
}

# --- Dry Run Logic ---
DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true && echo -e "${MAGENTA}--- DRY RUN MODE ENABLED ---${NC}\n"

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${MAGENTA}[DRY-RUN] Executing:${NC} $@"
    else
        "$@"
    fi
}

# --- 1. Distro Detection ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi

show_banner

# --- 2. Pre-flight (Dependencies & TUI Tool) ---
echo -e "${CYAN}Performing pre-flight checks...${NC}"
case $OS in
    fedora)
        run_cmd sudo dnf install -y git dnf-plugins-core curl newt
        ;;
    arch)
        run_cmd sudo pacman -S --needed --noconfirm git base-devel curl libnewt
        
        if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null && ! command -v aur &> /dev/null; then
            echo -e "${CYAN}No AUR helper found. Installing yay...${NC}"
            run_cmd git clone https://aur.archlinux.org/yay.git /tmp/yay
            if [ "$DRY_RUN" = false ]; then
                cd /tmp/yay && makepkg -si --noconfirm && cd - && rm -rf /tmp/yay
            fi
        fi
        
        # Determine helper for later
        if command -v yay &> /dev/null; then AUR_HELPER="yay";
        elif command -v paru &> /dev/null; then AUR_HELPER="paru";
        elif command -v aur &> /dev/null; then AUR_HELPER="aur sync -si";
        else AUR_HELPER="yay"; fi
        ;;
esac

# --- 3. TUI Component Selection ---
if [ "$DRY_RUN" = true ]; then
    CHOICES="Niri Noctalia Cursor Fuzzel Alacritty Fastfetch GTK4 Zsh Wallpapers Symlinks"
else
    CHOICES=$(whiptail --title "Lemon Niri Installer" --checklist \
    "Use Space to select/deselect, Enter to confirm:" 20 78 12 \
    "Niri" "Scroll-stacking compositor" ON \
    "Noctalia" "Status bar and shell" ON \
    "Cursor" "Bibata Modern Ice Theme" ON \
    "Fuzzel" "Application Launcher" ON \
    "Alacritty" "Terminal Emulator" ON \
    "Fastfetch" "Chafa & Lemon Logos" ON \
    "GTK4" "Required Libraries" ON \
    "Zsh" "Zsh + Oh My Zsh + Theme" ON \
    "Wallpapers" "Wallpaper Bank (~1GB)" OFF \
    "Symlinks" "Apply Lemon Dotfiles" ON 3>&1 1>&2 2>&3)
fi

# Exit if user cancels
[ $? -ne 0 ] && echo "Installation cancelled." && exit 1

# --- 4. Execution Logic ---

# Niri
if [[ $CHOICES == *"Niri"* ]]; then
    echo -e "${CYAN}Installing Niri...${NC}"
    case $OS in
        fedora) run_cmd sudo dnf copr enable -y yalter/niri-git && run_cmd sudo dnf install -y niri ;;
        arch)   run_cmd $AUR_HELPER --needed --noconfirm niri-git ;;
    esac
fi

# Noctalia
if [[ $CHOICES == *"Noctalia"* ]]; then
    echo -e "${CYAN}Installing Noctalia...${NC}"
    case $OS in
        fedora) 
            run_cmd sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
            run_cmd sudo dnf install -y noctalia-shell 
            ;;
        arch) run_cmd $AUR_HELPER --needed --noconfirm noctalia-shell ;;
    esac
fi

# Cursor
if [[ $CHOICES == *"Cursor"* ]]; then
    echo -e "${CYAN}Installing Bibata Cursor...${NC}"
    case $OS in
        fedora) run_cmd sudo dnf install -y bibata-cursor-themes ;;
        arch)   run_cmd $AUR_HELPER --needed --noconfirm bibata-cursor-theme-bin ;;
    esac
fi

# Standard Packages
PKG_LIST=()
[[ $CHOICES == *"Fuzzel"* ]] && PKG_LIST+=("fuzzel")
[[ $CHOICES == *"Alacritty"* ]] && PKG_LIST+=("alacritty")
[[ $CHOICES == *"Fastfetch"* ]] && PKG_LIST+=("fastfetch" "chafa")
[[ $CHOICES == *"GTK4"* ]] && PKG_LIST+=("gtk4")

if [ ${#PKG_LIST[@]} -ne 0 ]; then
    echo -e "${CYAN}Installing selected packages...${NC}"
    case $OS in
        fedora) run_cmd sudo dnf install -y "${PKG_LIST[@]}" ;;
        arch)   run_cmd sudo pacman -S --needed --noconfirm "${PKG_LIST[@]}" ;;
    esac
fi

# Zsh Setup
if [[ $CHOICES == *"Zsh"* ]]; then
    echo -e "${CYAN}Configuring Zsh Shell...${NC}"
    case $OS in
        fedora) run_cmd sudo dnf install -y zsh ;;
        arch)   run_cmd sudo pacman -S --needed --noconfirm zsh ;;
    esac
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        run_cmd sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] && run_cmd git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] && run_cmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
    
    run_cmd sudo chsh -s $(which zsh) $USER
fi

# Wallpapers
if [[ $CHOICES == *"Wallpapers"* ]]; then
    echo -e "${CYAN}Cloning Wallpapers...${NC}"
    run_cmd mkdir -p "$HOME/Pictures"
    [ ! -d "$WALLPAPER_DIR" ] && run_cmd git clone --depth 1 "$WALLPAPER_URL" "$WALLPAPER_DIR"
fi

# Dotfiles & Symlinks
if [[ $CHOICES == *"Symlinks"* ]]; then
    echo -e "${CYAN}Applying Dotfiles...${NC}"
    [ ! -d "$DOTFILES_DIR" ] && run_cmd git clone "$REPO_URL" "$DOTFILES_DIR"
    [ "$DRY_RUN" = false ] && mkdir -p "$HOME/.config" "$BACKUP_DIR"

    if [ -f "$DOTFILES_DIR/zshrc" ]; then
        [ "$DRY_RUN" = false ] && [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/.zshrc.bak" 2>/dev/null
        run_cmd ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    fi

    for cfg in "niri" "alacritty" "fuzzel" "noctalia"; do
        if [ -d "$DOTFILES_DIR/$cfg" ]; then
            run_cmd ln -sf "$DOTFILES_DIR/$cfg" "$HOME/.config/"
        fi
    done
fi

# --- 5. Final Notice ---
if systemd-detect-virt | grep -q "oracle"; then
    echo -e "\n${MAGENTA}VirtualBox detected: Ensure 3D Acceleration is ON!${NC}"
fi

echo -e "\n${GREEN}Lemon Niri setup complete! Reboot or Logout To apply changes.${NC}"
echo -e "${CYAN}Github : aeroslayys${NC}"
