# Clone the repo into "$HOME/src/gogh"
sudo dnf install git -y
mkdir -p "$HOME/src"
cd "$HOME/src"
git clone https://github.com/Gogh-Co/Gogh.git gogh
cd gogh

# necessary in the Gnome terminal on ubuntu
export TERMINAL=gnome-terminal

# Enter theme installs dir
cd installs

# install themes
./gruvbox-dark.sh