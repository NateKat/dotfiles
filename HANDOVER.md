# zsh terminal setup — handover for Claude Code

Paste or attach this file in a Claude Code session on a new Mac and say
"set this up". It describes the full terminal setup (Oh My Zsh, powerlevel10k,
plugins and CLI tools) so Claude can reproduce it, and lists the steps the
user has to do by hand.

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
- Check the result with `zsh -l -i -c '...'`. A shell without a terminal may
  print `gitstatus failed to initialize` or `can't change option: zle`; that is
  expected and harmless. Only a real terminal tab tells you for sure.
- Use a task list and report at the end what was done and what the user still
  has to do (section 8).

## 1. Homebrew and PATH

If Homebrew isn't installed, ask the user to install it from https://brew.sh
(it needs their password).

Put Homebrew **first** in PATH. Otherwise the macOS versions of `zsh` and `jq`
take priority over the Homebrew ones. Add this at the **top** of `~/.zprofile`:

```zsh
# Homebrew: put /opt/homebrew/bin ahead of system tools
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 2. Install packages

```bash
brew install zsh lsd bat fzf zoxide ripgrep fd git-delta jq tlrc
brew install --cask font-meslo-lg-nerd-font
```

- `tlrc` is the official `tldr` client. The old `tldr` formula is disabled in
  Homebrew. The command is still `tldr`.
- The MesloLGS Nerd Font is required for powerlevel10k and lsd icons.

## 3. Oh My Zsh, theme and plugins

```bash
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git            "$ZSH_CUSTOM/themes/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
```

(These three are git clones, so update them with `git pull` in each folder.
`brew upgrade` doesn't cover them.)

## 4. `~/.zshrc`

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

**d. Append at the end of the file**, after the p10k line
(`[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh`). Running `p10k configure`
adds that line, and the "instant prompt" block at the top of the file:

```zsh
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
```

## 5. git + delta

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

## 6. powerlevel10k prompt

If a `p10k.zsh` file is in this repo, copy it to `~/.p10k.zsh` and you're
done. Otherwise the user has to run the wizard themselves, since it asks
questions (`p10k configure` in a real terminal, after the font is set). These
are the answers to give:

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

The original config header reads:
`nerdfont-v3 + powerline, small icons, rainbow, unicode, round separators,
round heads, flat tails, 1 line, compact, many icons, fluent,
transient_prompt, instant_prompt=verbose`.

## 7. Verify

```bash
zsh -l -i -c 'echo $ZSH_THEME; echo $plugins; whence -p jq zsh; alias ls cat gll; bindkey "^R"; type z | head -1; git config --get core.pager'
```

You should see the powerlevel10k theme, all three plugins,
`/opt/homebrew/bin/jq` and `/opt/homebrew/bin/zsh`, the aliases,
`fzf-history-widget` bound to `^R`, `z` defined as a function, and `delta`.

## 8. Steps the user must do by hand

1. **Terminal font**: set it to **MesloLGS Nerd Font Mono**. In Terminal or
   iTerm2: Settings → Profiles → Text → Font. In the VS Code terminal:
   `"terminal.integrated.fontFamily": "MesloLGS Nerd Font Mono"`.
2. **Run `p10k configure`** in a new tab with the answers from section 6,
   unless `p10k.zsh` was copied from this repo.
3. **Optional: make the Homebrew zsh the login shell** (needs a password):
   ```bash
   echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells
   chsh -s /opt/homebrew/bin/zsh
   ```
4. Open a new terminal tab (or `exec zsh -l`).

## Cheat sheet

| Keys / command | Does |
|---|---|
| → (right arrow) | Accept the grey autosuggestion |
| Ctrl-R / Ctrl-T / Alt-C | fzf: search history / pick a file (bat preview) / cd into a folder (tree preview) |
| `z foo` / `zi` | Jump to a frequently used folder / pick one with fzf |
| `ll`, `la`, `lt` | lsd long list / with hidden files / tree |
| `rg pattern`, `fd name` | Fast grep / find |
| `gll` | Last 17 commits, one line each |
| `n` / `N` in `git diff` | Jump to the next / previous file (delta) |
| `tldr <cmd>` | Short usage examples |
| `p10k configure` | Re-run the prompt wizard |
