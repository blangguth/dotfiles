```
   ____   __  ____  ____  __  __    ____  ____ 
  (    \ /  \(_  _)(  __)(  )(  )  (  __)/ ___)
   ) D ((  O ) )(   ) _)  )( / (_/\ ) _) \___ \
  (____/ \__/ (__) (__)  (__)\____/(____)(____/
 
 ###########
 # about   # custom linux config files
 # author  # xero <x@xero.nu>
 # └author # blangguth <dev@langguth.io>
 # code    # https://github.com/blangguth/dotfiles
 ###########

 in use
 ------
 bash           > .bashrc with git prompt, .profile and aliases
 feh            > image viewer themes
 git            > global git config and aliases
 gtk            > gtk 2, 3 and 4 theme, icon and font settings
 mc             > midnight commander settings, panels, user menu and dracula skin
 polybar        > status bar config
 urxvt          > terminal settings, xft and dracula colors in .Xresources
 vim            > neobundle plugins and dracula color scheme
 xmonad         > xmonad wm config, helper scripts and stack build files
 xsession       > .xsessionrc starts polybar, urxvtd and xmonad, .xserverrc

 not in use on this machine (mostly inherited from xero)
 -------------------------------------------------------
 fonts          > configs for gohu and other bitmap fonts
 fun            > term color, sys info, and other misc scripts
 pacman         > pacman colors and progress bar animations (arch only)
 ranger         > file manager with image previews and z3bra theme
 ryu-login      > ryu ansi art for /etc/issue tty login
 ssh            > remote ssh server keep alive
 sys            > system automation scripts
 themes         > mod of the cathexis dark theme for gtk/qt/xfce
 tmux           > terminal multiplexer with custom status bar
 zsh            > zshell settings, aliases, and custom prompts

 assets (flat folders, do not stow)
 ----------------------------------
 figlet         > custom 3d font
 previews       > screenshots of xero's original setups
 wallpaper      > desktop background images
```

## table of contents
 - [introduction](#dotfiles)
 - [my setup](#my-setup)
 - [installing](#installing)
 - [how it works](#how-it-works)
 - [tl;dr](#tldr)
 - [new machine](#new-machine)
 - [xmonad](#xmonad)
 - [vim](#vim)

# dotfiles
personal linux config files, forked from [xero/dotfiles](https://github.com/xero/dotfiles) and managed with [gnu stow](https://www.gnu.org/software/stow/), a small symlink farm manager. every top level folder is a package that mirrors the home directory, so `vim/.vimrc` ends up as `~/.vimrc`. the files stay versioned in one place and are linked into position with a single command.

# my setup
- **os:** debian
- **shell:** bash
- **window manager:** [xmonad](https://xmonad.org) with [polybar](https://github.com/polybar/polybar)
- **terminal:** urxvt in daemon/client mode
- **launcher:** dmenu via yeganesh
- **editor:** vim
- **file manager:** midnight commander
- **colors:** [dracula](https://draculatheme.com) (`#282A36`, `#BD93F9`)

# installing
stow is available through your package manager.

- `sudo apt-get install stow`
- `sudo pacman -S stow`
- `brew install stow`

# how it works
by default stow creates symlinks in the parent directory of where you run it. so this setup assumes the repo is located at `~/dotfiles` and that all stow commands run inside that directory. otherwise use the `-d` flag with the repo location.

to install a package run stow with the folder name as the only argument:

`stow vim`

use the `-t` (target) flag to link files somewhere else. **ryu-login** and **pacman** target the root of the filesystem:

`sudo stow -t / ryu-login`

**note:** stow will not replace a real file. if a file already exists in the target location stow refuses to link it. move the file out of the way first, and compare it with the repo copy before you do. don't use `--adopt`, it overwrites the repo copy with the file from your home directory.

this applies here to `ssh`: `~/.ssh/config` is a real file on this machine and stays out of the repo, the repo copy is only a stub. also `~/.config/mc/menu` is a hand made link to `mc.menu`, `stow mc` would not create it.

some programs write to linked files. mc rewrites `ini` when it exits, so a diff in that file is expected and doesn't need a commit. theme switchers can replace a gtk `settings.ini` with a real file, `ls -l` shows whether it's still a link.

# tl;dr
clone the repo into your home directory

`cd ~`

`git clone https://github.com/blangguth/dotfiles.git`

enter the dotfiles directory

`cd dotfiles`

preview what a package would do, this changes nothing

`stow -n -v vim`

install a package

`stow vim`

uninstall a package

`stow -D vim`

# new machine
this repo only holds configs. a fresh debian install needs a few more things before the desktop works.

**packages**

`sudo apt-get install stow vim mc xmonad polybar rxvt-unicode suckless-tools feh scrot alsa-utils xbacklight x11-xserver-utils network-manager-applet keychain colordiff net-tools`

stack builds xmonad against the x11 headers:

`sudo apt-get install libx11-dev libxft-dev libxinerama-dev libxrandr-dev libxss-dev`

**tools outside the package manager**

- [stack](https://docs.haskellstack.org) and yeganesh in `~/.local/bin`
- [nvm](https://github.com/nvm-sh/nvm) in `~/.nvm`, then `nvm alias default 26`
- [rustup](https://rustup.rs) for `~/.cargo/env`
- [homebrew](https://brew.sh) in `/home/linuxbrew/.linuxbrew`
- the git prompt: `git clone https://github.com/blangguth/bash-git-prompt.git ~/.bash-git-prompt`

`.bashrc` falls back to a plain prompt without bash-git-prompt and skips keychain, brew, nvm and `~/.cargo/env` when they're missing, `.profile` does the same for nvm and `~/.cargo/env`. keychain also needs `~/.ssh/id_rsa`.

**theme, icons and fonts**

- the [dracula gtk theme](https://draculatheme.com/gtk) in `~/.themes/Dracula`
- the [tela icon theme](https://github.com/vinceliuice/Tela-icon-theme): run `./install.sh dracula` in a clone of it, then `gsettings set org.gnome.desktop.interface icon-theme Tela-dracula-dark`
- fonts: SauceCodePro Nerd Font for urxvt, polybar and dmenu, with DejaVu Sans Mono and DejaVu Sans as fallbacks, Noto Sans for gtk

**first start**

`.xsessionrc` starts the xmonad binary directly, so build it before the first login and link it for `xmonad --restart`:

`xmonad --recompile`

`mkdir -p ~/.local/bin`

`ln -s ~/.xmonad/xmonad-x86_64-linux ~/.local/bin/xmonad`

# xmonad
the config is `xmonad/.xmonad/xmonad.hs`, the mod key is super. it builds with [stack](https://docs.haskellstack.org) (ghc 9.4.7 from `lts-21.12`, xmonad 0.18.1 from hackage), so `stack.yaml` and `xmonad-config.cabal` have to stay next to it.

rebuild and restart after a change:

`xmonad --recompile && xmonad --restart`

the scripts in `bin/` are expected on the `PATH` as `~/.xmonad/bin`.

# vim
plugins are managed with [neobundle](https://github.com/Shougo/neobundle.vim), which is part of this repo. all other plugins are downloaded into `vim/.vim/bundle/`, which is ignored by git. add new ones as `NeoBundle` lines in `vim/.vimrc`.

- [unite](https://github.com/Shougo/unite.vim) - search and display lists
- [ag](https://github.com/rking/ag.vim) - the silver searcher from vim
- [nerdtree](https://github.com/scrooloose/nerdtree) - file tree
- [airline](https://github.com/bling/vim-airline) - status line
- [dracula](https://github.com/dracula/vim) - the active color scheme
- [gruvbox](https://github.com/morhetz/gruvbox) and [base16](https://github.com/chriskempson/base16-vim) - alternative color schemes
