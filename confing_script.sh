#! /bin/bash

file="/home/kali/.fzf/completion.zsh"


# Check if running with sudo
if [ $(id -u) -ne 0 ]
  then 
    echo "Please run this script as root or using sudo!"
  exit
fi


# List of programs to install
prog=("bat" "grc"  "lsd" "rlwrap" "zenity" "konsole" "code")

# Loop to check each program from list 
for programs in "${prog[@]}"; do
    if command -v "$programs" &> /dev/null; then
        echo "$programs is installed , doing nothing "
    else
        echo "$programs is not installed, will install for you "
        sudo apt update && apt install "$programs" -y 
    fi
done


# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# Check if file exist if not create 

if [ ! -f "$file" ]; then
    echo "File does not exist. Creating file: $file, and writing confign script"
    touch $file
else
    echo "File already exists: $file"
    exit 0
fi

# Create fzf file and write custom script
cat << EOF >> $file

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    tree)         find .  | fzf  --height 60%  --reverse  --border="sharp" --border-label="" --preview-window="sharp"   --preview '[ -d {} ] && tree -C {} || batcat --color=always --style=numbers {}' "$@";;
    
    *)            fzf "$@" ;;
  esac
}

EOF

exit 0






