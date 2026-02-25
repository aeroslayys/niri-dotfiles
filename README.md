# 🍋 Lemon Niri Dotfiles

![Preview of my Lemon Niri Setup](preview.png)

A citrus-themed Wayland desktop built around **Niri** with proportional tiling and bold yellow accents.

Minimal. Bright. Functional.

---

# 📸 Preview

> This setup uses `fastfetch` rendered through `chafa` for the custom lemon logo.

---

# 🚀 Installation

## ✅ Recommended: Manual Installation

Manual installation is strongly recommended so you:

- Understand system changes  
- Control backups  
- Avoid unintended overwrites  
- Learn your environment structure  

---

# 📦 Manual Install Steps

## 1️⃣ Install Core Dependencies

Install the following packages:

- `niri`
- `alacritty`
- `fastfetch`
- `chafa`
- `git`

### Fedora

```bash
sudo dnf install niri alacritty fastfetch chafa git
```

### Arch

```bash
sudo pacman -S --needed niri alacritty fastfetch chafa git
```

---

## 2️⃣ Install Noctalia (Status Bar)

### Arch

```bash
yay -S noctalia-shell
```

### Fedora

```bash
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
sudo dnf install noctalia-shell
```

---

## 3️⃣ Clone Dotfiles

```bash
git clone https://github.com/aeroslayys/niri-dotfiles ~/niri-dotfiles
```

---

## 4️⃣ Backup Existing Configs

```bash
mkdir -p ~/dotfiles_backup
mv ~/.config/niri ~/dotfiles_backup/ 2>/dev/null
mv ~/.config/alacritty ~/dotfiles_backup/ 2>/dev/null
mv ~/.config/fuzzel ~/dotfiles_backup/ 2>/dev/null
```

---

## 5️⃣ Symlink Configurations

```bash
mkdir -p ~/.config
ln -sf ~/niri-dotfiles/niri ~/.config/
ln -sf ~/niri-dotfiles/alacritty ~/.config/
ln -sf ~/niri-dotfiles/fuzzel ~/.config/ 2>/dev/null
```

---

## 6️⃣ Optional: Zsh Lemon Config

```bash
cat ~/niri-dotfiles/zshrc >> ~/.zshrc
```

- Appends configuration
- Does NOT overwrite existing `.zshrc`
- Safe to re-run

---

# ⚠️ Interactive Auto Installer

An interactive installer script is included.

✔ Supports:
- Fedora  
- Arch  

✔ Fully interactive  
✔ Safe backups  
✔ `--dry-run` support  
✔ Handles AUR + COPR automatically  

---

# 🧪 Dry Run Mode

Preview everything without making changes:

```bash
bash install.sh --dry-run
```

Or:

```bash
bash <(curl -sSL https://gist.githubusercontent.com/aeroslayys/48301affed815e0ed09d492c48f3322a/raw) --dry-run
```

---

# ▶ Execute Installer

```bash
bash install.sh
```

Or:

```bash
bash <(curl -sSL https://gist.githubusercontent.com/aeroslayys/48301affed815e0ed09d492c48f3322a/raw)
```

---

# 🧠 What the Installer Does

## ✔ Distro Detection

- Detects system using `/etc/os-release`
- Fedora → `dnf`
- Arch → `pacman` + `yay`

---

## ✔ Pre-Flight Checks

### Fedora
- Installs `git`
- Installs `dnf-plugins-core` if missing

### Arch
- Installs `git`
- Installs `base-devel`
- Installs `yay` automatically if missing

---

## ✔ Special Package Handling

### Niri
- Fedora → Enables COPR `yalter/niri-git`
- Arch → Installs `niri-git` from AUR

### Noctalia
- Fedora → Enables Terra repo automatically
- Arch → Installs via `yay`

### GTK4
- Automatically installs if missing

---

## ✔ Interactive Component Selection

You can choose to install:

- Niri (Window Manager)
- Noctalia (Status Bar)
- Fuzzel (App Launcher)
- Alacritty (Terminal)
- Fastfetch & Chafa
- Zsh

Nothing installs without confirmation.

---

## ✔ Wallpaper Bank (Optional ~1GB)

Optionally clones:

```
Wallpaper-Bank
```

Into:

```
~/Pictures/Wallpaper-Bank
```

Uses shallow clone (`--depth 1`).

---

## ✔ Automatic Gruvbox Theme (Optional)

If selected, writes a Gruvbox profile to:

```
~/.config/noctalia/colors.json
```

Includes:
- Proper primary/secondary accents
- Surface contrast
- Lemon-friendly palette

---

## ✔ Safe Dotfile Handling

- Clones repo if missing
- Creates timestamped backup:

```
~/dotfiles_backup_YYYYMMDD_HHMMSS
```

- Backs up existing configs
- Creates clean symlinks

---

## ✔ Zsh Integration

- Appends lemon config only if not already present
- Never overwrites `.zshrc`
- Safe for repeated runs

---

## ✔ VirtualBox Detection

If running in VirtualBox, the installer recommends:

### Fedora
```bash
sudo dnf install virtualbox-guest-additions
```

### Arch
```bash
sudo pacman -S virtualbox-guest-utils
```

---

# 🛠️ Components Overview

| Category      | Tool        |
|--------------|------------|
| Compositor   | Niri       |
| Terminal     | Alacritty  |
| Status Bar   | Noctalia   |
| Launcher     | Fuzzel     |
| System Info  | Fastfetch  |
| ASCII Render | Chafa      |
| Shell        | Zsh        |

---

# ⚙️ Key Specs

- **Window Ratio:** 0.5 default column width  
- **Theme:** Gruvbox-inspired citrus contrast  
- **Layout:** Proportional tiling  
- **Bar:** Noctalia (GTK4-based)  
- **Installer:** Interactive with dry-run support  

---

# 🍋 Philosophy

A high-contrast, proportional Wayland workflow with citrus identity.

Designed for clarity, speed, and simplicity.

---

Enjoy your Lemon Niri setup 🍋
