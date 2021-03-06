#!/bin/sh

#TODO: make all the backup shit configurable
#Just make the logic better, such as make the options definable in one place
#only

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd )"

bootstrap_options=("vim" "bash" "zsh" "i3" "i3blocks" "x" "termite" "wallpaper" "gtk")
special_options=("all" "options")
options=("${special_options[@]}" "${bootstrap_options[@]}")
initial_params="$@"

# Usage: in_list <string> <strings>
in_list() {
  for item in "${@:2}"
  do
    if [[ "$item" == "$1" ]]; then
      return 0
    fi
  done
  return 1
}

bootstrap_vim() {
  echo "source $SCRIPTPATH/vim/main.vim" > $SCRIPTPATH/vim/.vimrc
  cp -b $SCRIPTPATH/vim/.vimrc ~
  echo "done bootstraping vim"
}

bootstrap_bash() {
  cp -b $SCRIPTPATH/bash/.bash* ~
  echo "done bootstraping bash"
}

bootstrap_zsh() {
  cp -b $SCRIPTPATH/zsh/.zsh* ~
  echo "done bootstraping zsh"
}

bootstrap_i3() {
  mkdir -p ~/.config/i3
  cp -b $SCRIPTPATH/i3/* ~/.config/i3/
  echo "done bootstraping i3"
}

bootstrap_i3blocks() {
  mkdir -p ~/.config/i3blocks
  cp -b $SCRIPTPATH/i3blocks/* ~/.config/i3blocks/
  echo "done bootstraping i3blocks"
}

bootstrap_x() {
  mkdir -p ~/.config
  mkdir -p ~/.xdg
  cp -b $SCRIPTPATH/x/.xinitrc ~
  cp -b $SCRIPTPATH/x/user-dirs.dirs ~/.config
  echo "done bootstraping x"
}

bootstrap_termite() {
  mkdir -p ~/.config/termite
  cp -b $SCRIPTPATH/termite/* ~/.config/termite/
  echo "done bootstraping termite"
}

bootstrap_wallpaper() {
  cat > $SCRIPTPATH/wallpapers/.fehbg <<- EOM
#!/bin/sh
'feh' '--bg-scale' '$SCRIPTPATH/wallpapers/wallpaper'
EOM
  chmod +x $SCRIPTPATH/wallpapers/.fehbg
  cp -b $SCRIPTPATH/wallpapers/.fehbg ~
  echo "done bootstraping wallpaper"
}

bootstrap_gtk() {
  mkdir -p ~/.config/gtk-3.0
  cp -b $SCRIPTPATH/gtk/gtk.css ~/.config/gtk-3.0
  echo "done bootstraping gtk"
}

bootstrap_by_param() {
  case "$1" in
    "vim") bootstrap_vim;;
    "bash") bootstrap_bash;;
    "zsh") bootstrap_zsh;;
    "i3") bootstrap_i3;;
    "i3blocks") bootstrap_i3blocks;;
    "x") bootstrap_x;;
    "termite") bootstrap_termite;;
    "wallpaper") bootstrap_wallpaper;;
    "gtk") bootstrap_gtk;;
  esac
}

bootstrap_by_params() {
  for param do
    bootstrap_by_param "$param";
  done
}

print_usage() {
  ( IFS='|'; echo "usage: ./bootstrap.sh all | ./bootstrap.sh options | ./bootstrap.sh ${bootstrap_options[*]}" )
}

exit_invalid_usage() {
  echo "invalid arguments: $initial_params"
  print_usage
  exit 1
}

validate_params() {
  for param do
    if ! in_list "$param" "${options[@]}"; then
      exit_invalid_usage
    fi;
  done
}

validate_special_params() {
  for param do
    if in_list "$param" "${special_options[@]}"; then
      found_special=true
    fi;
  done

  if [ \( "$#" -gt 1 \) -a \( "$found_special" = true \) ]; then
    exit_invalid_usage
  fi
}

handle_special_params() {
  validate_special_params "$@"

  case "$1" in
    "all")
      bootstrap_by_params "${bootstrap_options[@]}"
      exit 0;;
    "options")
      print_usage
      exit 0;;
  esac
}

main() {
  validate_params "$@"

  handle_special_params "$@"

  bootstrap_by_params "$@"
}

main $@

