[[ -f ~/.zshrc ]] && . ~/.zshrc

# Auto start Xorg on login to tty1
if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  exec startx
fi

