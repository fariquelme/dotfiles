# Install libraries and packages for nvim
pip install jupytext
pip install ipywidgets
pip install nbdime
pip install pynvim
pip install flake8 
pip install autopep8 
apt install ripgrep
npm install -g eslint
npm install -g neovim
npm install -g prettier
apt install neovim

# Other tools
htop tmux

# Pyenv
apt update; apt install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl https://pyenv.run | zsh

# Node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
nvm install --lts

# Use zsh as default shell
chsh fariquelme -s /bin/zsh
