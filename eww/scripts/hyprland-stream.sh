#!/usr/bin/env bash

function get_workspaces {
  echo "$(hyprctl workspaces -j | jq -c '[sort_by(.id).[].name | {id: ., name: .} | select(.id == "special:magic").name |= "S"]')"
}

# call once at startup to load workspaces with default open windows
eww update workspaces=$(get_workspaces)
last_workspace=$(eww get active-workspace)

function handle {
  echo $1
  # %% prevents splitting in a wrong place if >> is in the window title
  # https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
  command=${1%%>>*}
  value=${1#*>>}

  case $command in

  "workspace")
    # set active workspace
    eww update active-workspace=$value
    # update open workspaces
    eww update workspaces=$(get_workspaces)

    last_workspace=$(eww get active-workspace)
    ;;
  "activespecial")
    ws="${value%%,*}"
    [ -z "$ws" ] && ws=$last_workspace
    # set active workspace
    # eww update active-workspace=$ws
    # update open workspaces
    eww update workspaces=$(get_workspaces)
    ;;
  "activelayout")
    kb=${value%%,*}
    layout=${value#*,}
    # Ignore hl-virtual-keyboard as it switches to default on window focus change
    if [ "$kb" != "hl-virtual-keyboard" ]; then
      eww update kb-layout="$layout"
    fi
    ;;
  "movewindow")
    eww update workspaces=$(get_workspaces)
    ;;
  "destroyworkspace")
    # update open workspaces
    eww update workspaces=$(get_workspaces)
    ;;
  "monitorremoved")
    if [ "$value" == "FALLBACK" ]; then
      eww open bar
    fi
    ;;

  esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
  while read -r line; do handle "$line"; done
