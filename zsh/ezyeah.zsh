# ── EzYeah ───────────────────────────────────────────────────────────────
alias tests='cd ~/Documents/ezyeah && git checkout main && git pull && ./scripts/run-tests.sh'
alias dkr='cd ~/Documents/ezyeah && git pull && { docker compose -p ezyeah down --remove-orphans; docker compose -f infra/compose.yml up; }'

# EzYeah prod banner: letters sweep in with a spark, cyan→magenta gradient, PROD flashes red
_ezyeah_rows=(
  '┏━╸ ╺━┓ ╻ ╻ ┏━╸ ┏━┓ ╻ ╻   ┏━┓ ┏━┓ ┏━┓ ╺┳┓'
  '┣╸  ┏━┛ ┗┳┛ ┣╸  ┣━┫ ┣━┫   ┣━┛ ┣┳┛ ┃ ┃  ┃┃'
  '┗━╸ ┗━╸  ╹  ┗━╸ ╹ ╹ ╹ ╹   ╹   ╹┗╸ ┗━┛ ╺┻┛'
)
_ezyeah_draw() {  # $1 = columns shown, $2 = color override for PROD
  local LC_ALL=en_US.UTF-8 out='' i c
  for i in 1 2 3; do
    for (( c = 1; c <= $1; c++ )); do
      if (( c == $1 && $1 < w )); then out+=$'\e[1;97m'
      elif (( c > split )) && [[ -n $2 ]]; then out+=$2
      else out+=$col[c]; fi
      out+=${_ezyeah_rows[i][c]}
    done
    out+=$'\e[0m\e[K\n'
  done
  print -rn -- "$out"$'\e[3A'
}
_ezyeah_banner() {
  local LC_ALL=en_US.UTF-8
  if [[ ! -t 1 ]]; then print -l -- $_ezyeah_rows; return; fi
  zmodload zsh/zselect
  local w=${#_ezyeah_rows[1]} split=23 n c
  local -a col
  for (( c = 1; c <= w; c++ )); do
    if (( c <= split )); then
      col[c]=$'\e[1;38;2;'$(( 255 * (c-1) / (split-1) ))';'$(( 230 - 230 * (c-1) / (split-1) ))$';255m'
    else
      col[c]=$'\e[1;38;2;255;60;60m'
    fi
  done
  print -n $'\e[?25l'
  {
    for (( n = 1; n <= w; n++ )); do _ezyeah_draw $n; zselect -t 1; done
    for n in 1 2 3; do
      _ezyeah_draw $w $'\e[1;38;2;255;220;0m'; zselect -t 8
      _ezyeah_draw $w; zselect -t 8
    done
  } always {
    print -n $'\e[3B\e[?25h'
  }
}

# prod: show the banner, then ssh to the prod VM with tunnels (extra args go to ssh)
prod() {
  _ezyeah_banner
  ssh -i ~/.ssh/__PROD_KEY_FILE__ \
    -L 8001:localhost:8000 \
    -L 6001:localhost:6001 \
    -L 6002:localhost:6002 \
    ubuntu@__PROD_HOST__ "$@"
}
