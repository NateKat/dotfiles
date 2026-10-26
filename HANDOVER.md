# Mac terminal & dev setup — handover for Claude Code

Paste or attach this file in a Claude Code session on a new Mac and say
"set this up". It describes the full setup (iTerm2 with its profiles,
Oh My Zsh, powerlevel10k, zsh plugins, CLI tools, Node via nvm and desktop
apps) so Claude can reproduce it, and lists the steps the user has to do by
hand.

## Instructions for Claude

- Target: macOS on Apple Silicon (Homebrew in `/opt/homebrew`). On Intel Macs
  Homebrew lives in `/usr/local`; adjust paths.
- Make every step idempotent: check whether a tool, plugin or line is already
  there before adding it, and never add a line twice.
- Before editing `~/.zshrc`, `~/.zprofile` or `~/.gitconfig`, back each one up
  (e.g. `~/.zshrc.bak-<date>`). Keep any existing machine-specific lines
  (Docker, OrbStack, credential helpers, etc.). Merge, don't replace.
- The Oh My Zsh installer replaces `~/.zshrc` (saving the old one as
  `~/.zshrc.pre-oh-my-zsh`). Copy anything from the old file back into the new
  one.
- Section 3 lists optional desktop apps. Ask the user which ones they want
  before installing.
- Check the result with `zsh -l -i -c '...'`. A shell without a terminal may
  print `gitstatus failed to initialize` or `can't change option: zle`; that is
  expected and harmless. Only a real terminal tab tells you for sure.
- Use a task list and report at the end what was done and what the user still
  has to do (section 11).

## 0. Get this repo

The iTerm2 profiles and the powerlevel10k config live next to this file.
Clone the repo first. A public repo needs no sign-in; `gh` comes in step 2 if
`git` isn't installed yet.

```bash
git clone https://github.com/NateKat/dotfiles.git ~/dotfiles
```

| File | What it is |
|---|---|
| `HANDOVER.md` | This file |
| `p10k.zsh` | powerlevel10k prompt config → `~/.p10k.zsh` |
| `iterm2/profiles.json` | iTerm2 profiles "Main" and "Quake" (F2 hotkey window) |
| `zsh/ezyeah.zsh` | EzYeah shortcuts `tests`, `dkr`, `prod` + animated banner (section 6f) |
| `zshrc` | An older (2022) zshrc for reference only. **Don't install it**; section 6 is the current setup |

## 1. Homebrew and PATH

If Homebrew isn't installed, ask the user to install it from https://brew.sh
(it needs their password).

Put Homebrew **first** in PATH. Otherwise the macOS versions of `zsh` and `jq`
take priority over the Homebrew ones. Add this at the **top** of `~/.zprofile`:

```zsh
# Homebrew: put /opt/homebrew/bin ahead of system tools
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 2. Command-line tools

```bash
brew install zsh lsd bat fzf zoxide ripgrep fd git-delta jq tlrc \
             gh tig htop vim
brew install hashicorp/tap/terraform
brew install --cask font-meslo-lg-nerd-font
```

- `tlrc` is the official `tldr` client. The old `tldr` formula is disabled in
  Homebrew. The command is still `tldr`.
- The MesloLGS Nerd Font is required for powerlevel10k and lsd icons; the
  iTerm2 profile uses it at size 18.
- `gh`: the user signs in themselves with `gh auth login`, which also sets up
  git credentials for GitHub.

## 3. Desktop apps (ask first)

| App | Install | Notes |
|---|---|---|
| iTerm2 | `brew install --cask iterm2` | **Required** for section 9 |
| Rectangle | `brew install --cask rectangle` | Window snapping. Needs Accessibility permission (user grants it) |
| OrbStack | `brew install --cask orbstack` | Docker/Linux VMs. Adds its own line to `~/.zprofile`; keep it |
| Docker Desktop | `brew install --cask docker-desktop` | Usually only one of OrbStack / Docker is needed; ask |
| Obsidian | `brew install --cask obsidian` | Notes |
| Amphetamine | Mac App Store only | Keeps the Mac awake. The user installs it from the App Store |

Other apps on the old Mac, if the user wants them too: Google Chrome
(`google-chrome`), Slack (`slack`), Zoom (`zoom`), WhatsApp (`whatsapp`),
Microsoft PowerPoint (`microsoft-powerpoint`). All are Homebrew casks.

## 4. Oh My Zsh, theme and plugins

```bash
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git            "$ZSH_CUSTOM/themes/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
```

(These three are git clones, so update them with `git pull` in each folder.
`brew upgrade` doesn't cover them.)

## 5. Node.js via nvm

Install nvm with its official script. Check https://github.com/nvm-sh/nvm
for the latest version; v0.40.8 was used before. The script appends the
`NVM_DIR` lines to `~/.zshrc` itself (shown in section 6d). Then install
Node 24 and make it the default:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
nvm install 24
nvm alias default 24
```

## 6. `~/.zshrc`

Start from the `~/.zshrc` the Oh My Zsh installer generates, then:

**a. Set the theme** (replace the `ZSH_THEME=` line):

```zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
```

**b. Set the plugins** (replace the `plugins=` line;
`zsh-syntax-highlighting` must stay last):

```zsh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

**c. Docker completions, only if Docker Desktop is installed.** Put this
**just before** `source $ZSH/oh-my-zsh.sh`, because Oh My Zsh runs `compinit`
and the path has to be added first. Drop Docker's own
`autoload -Uz compinit` / `compinit` lines:

```zsh
# Docker CLI completions (must be on fpath before oh-my-zsh runs compinit)
fpath=($HOME/.docker/completions $fpath)
```

**d. powerlevel10k instant prompt.** This block goes at the **very top** of
`~/.zshrc`:

```zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

**e. Append at the end of the file:**

```zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Custom aliases
alias gll="git --no-pager log -n 17 --abbrev-commit --decorate --date=short --format=tformat:'%Cgreen%h %C(yellow)%an%x09 %C(blue)%ad%Creset %C(red)%d%Creset %C(white)%s%Creset'"

# lsd / bat replacements for ls / cat
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree --depth 2'
alias cat='bat --paging=never'

# Shared color theme for bat and delta (list themes: bat --list-themes)
export BAT_THEME='Dracula'

# fzf: Ctrl-T files, Ctrl-R history, Alt-C cd (fd for faster, .gitignore-aware search)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}'"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --depth 2 --color=always --icon=always {}'"
source <(fzf --zsh)

# zoxide: `z <dir>` jumps to frequent dirs, `zi` picks with fzf
eval "$(zoxide init zsh)"

# nvm (added by the nvm installer, section 5)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

**f. EzYeah shortcuts** (`zsh/ezyeah.zsh` in this repo). Ask the user
whether they want them. If so:

1. Check that the project is cloned at `~/Documents/ezyeah`. If it's
   somewhere else, change the `cd` paths.
2. Ask the user for the prod **server IP** and the **SSH key file name** in
   `~/.ssh/`. They're private, so they're kept out of this public repo as
   `__PROD_HOST__` and `__PROD_KEY_FILE__`.
3. Append the contents of `zsh/ezyeah.zsh` to the end of `~/.zshrc`, with
   both placeholders filled in. Copy it; don't `source` it, since the
   placeholders would break `prod`.
4. Check it without connecting: `prod -G` makes ssh print its settings and
   exit. Look for the right `hostname`, `identityfile` and three
   `localforward` lines.

| Command | Does |
|---|---|
| `tests` | `cd ~/Documents/ezyeah`, check out `main`, `git pull`, run `./scripts/run-tests.sh` |
| `dkr` | `cd ~/Documents/ezyeah`, `git pull`, take down the `ezyeah` compose project, then `docker compose -f infra/compose.yml up` |
| `prod` | Plays a ~1 s animated "EZYEAH PROD" banner, then `ssh`s to the prod VM with tunnels `8001→8000`, `6001`, `6002` (extra args go to ssh) |

The banner is three lines of box-drawing letters. They sweep in from the
left with a white spark, shaded cyan→magenta, then "PROD" flashes yellow/red
three times. It uses 24-bit color (fine in iTerm2) and needs a UTF-8 font
(MesloLGS NF). When output isn't a terminal, it prints the plain three
lines with no animation.

(The old Mac also had an `ezs` alias for the same ssh command; `prod`
replaces it.)

## 7. git + delta

Add these to the global git config. Don't touch existing entries such as
credential helpers:

```bash
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global delta.syntax-theme Dracula
git config --global merge.conflictStyle zdiff3
```

## 8. powerlevel10k prompt

Copy the saved config (back up any existing one first):

```bash
cp ~/dotfiles/p10k.zsh ~/.p10k.zsh
```

That's all; the wizard isn't needed. For reference, or to recreate the prompt
with `p10k configure`, these were the answers:

| Wizard question | Answer |
|---|---|
| Font / icon checks (diamond, lock, arrow, Debian logo…) | **Yes** to each |
| Do the icons fit between the crosses? | **Yes** → *small icons* |
| Prompt style | **Rainbow** |
| Character set | **Unicode** |
| Show current time? | **No** |
| Prompt separators | **Round** |
| Prompt heads | **Round** |
| Prompt tails | **Flat** |
| Prompt height | **One line** |
| Prompt spacing | **Compact** |
| Icons | **Many icons** |
| Prompt flow | **Fluent** |
| Enable transient prompt? | **Yes** |
| Instant prompt mode | **Verbose** (recommended) |
| Apply changes to ~/.zshrc? | **Yes** |

## 9. iTerm2 profiles

`iterm2/profiles.json` is an iTerm2 *dynamic profile* file with two profiles:

- **Main**: the everyday profile. MesloLGS Nerd Font 18, separate colors for
  light and dark mode, visual bell, 1,000 lines of scrollback.
- **Quake**: a drop-down hotkey window. **F2** shows or hides it; it slides
  in, floats above other windows, stays open when it loses focus, and keeps
  40,000 lines of scrollback. It inherits everything else from **Main**.

Install it by copying the file. iTerm2 picks it up immediately, even while
running:

```bash
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
cp ~/dotfiles/iterm2/profiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/
```

Making **Main** the default profile is a user step (section 11).

## 10. Verify

```bash
zsh -l -i -c 'echo $ZSH_THEME; echo $plugins; whence -p jq zsh; alias ls cat gll; bindkey "^R"; type z | head -1; git config --get core.pager; node --version; [[ -f ~/.p10k.zsh ]] && echo p10k-ok'
ls ~/Library/Application\ Support/iTerm2/DynamicProfiles/
```

You should see the powerlevel10k theme, all three plugins,
`/opt/homebrew/bin/jq` and `/opt/homebrew/bin/zsh`, the aliases,
`fzf-history-widget` bound to `^R`, `z` defined as a function, `delta`, a
`v24.x` Node version, `p10k-ok`, and `profiles.json`.

## 11. Steps the user must do by hand

1. **Sign-ins and permissions:** `gh auth login`. Grant Rectangle
   Accessibility access when it asks. Install Amphetamine from the App Store
   if wanted.
2. **iTerm2 default profile:** Settings → Profiles → select **Main** → Other
   Actions… → **Set as Default**. This also sets the font.
3. **F2 for the Quake window:** on a MacBook keyboard F2 is screen brightness
   by default. Either press **fn+F2**, or turn on System Settings → Keyboard →
   Keyboard Shortcuts → Function Keys → "Use F1, F2, etc. keys as standard
   function keys".
4. **Other terminals:** if the user also uses Terminal.app or the VS Code
   terminal, set the font to **MesloLGS Nerd Font Mono** there. In VS Code:
   `"terminal.integrated.fontFamily": "MesloLGS Nerd Font Mono"`.
5. **Optional: make the Homebrew zsh the login shell** (needs a password):
   ```bash
   echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells
   chsh -s /opt/homebrew/bin/zsh
   ```
6. Open a new iTerm2 tab (or `exec zsh -l`).

## Cheat sheet

| Keys / command | Does |
|---|---|
| F2 (or fn+F2) | Show / hide the Quake drop-down terminal |
| → (right arrow) | Accept the grey autosuggestion |
| Ctrl-R / Ctrl-T / Alt-C | fzf: search history / pick a file (bat preview) / cd into a folder (tree preview) |
| `z foo` / `zi` | Jump to a frequently used folder / pick one with fzf |
| `ll`, `la`, `lt` | lsd long list / with hidden files / tree |
| `rg pattern`, `fd name` | Fast grep / find |
| `gll` | Last 17 commits, one line each |
| `tig` | Browse git history in the terminal |
| `n` / `N` in `git diff` | Jump to the next / previous file (delta) |
| `tldr <cmd>` | Short usage examples |
| `htop` | Process monitor |
| `tests` / `dkr` / `prod` | EzYeah: run tests / restart Docker stack / ssh to prod with banner |
| `p10k configure` | Re-run the prompt wizard |
