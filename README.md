
to install   omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-coppernight.git && { [ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar-backup-$RANDOM; }; mkdir -p ~/.config/waybar && cp -r ~/.config/omarchy/themes/coppernight/waybar/. ~/.config/waybar/ && killall waybar; waybar &
