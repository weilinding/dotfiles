EXCLUDED_DOTFILES := .git .git-crypt .gitattributes .gitignore .gitmodules .ssh
DOTFILES := $(addprefix ~/, $(filter-out $(EXCLUDED_DOTFILES), $(wildcard .*)))

DOTFILES_ROOT = /Users/wding/go/src/github.com/weilinding/dotfiles 
BREW = brew
CASK = brew

# Execute all commands per task in one shell, allowing for environment variables to be set for
# all following commands.
.ONESHELL:

# bootstrap only, add one-time bootstrap tasks here
# setups the necessary stuff
# restore .gnupg to decrypt the secrets from this repository
# setup ssh config (relies on decrypted repository)
boot: \
	bootstrap-fonts-directory \
	~/.ssh/config \
	zsh \
	dotfiles \
	defaults \
	tmux \
	brew \
	fonts \
	gotools \
	vim \
	casks \
	taps \
	java

bootstrap: \
	bootstrap-fonts-directory \
	bash \
	tmux \
	dotfiles \
	vim-directories \
	vim-plugins \
	~/.gnupg \
	~/.ssh/config \
	defaults

bootstrap-administrator: \
	bootstrap-fonts-directory \
	bash \
	tmux \
	casks-baseline \
	dotfiles \
	vim \
	defaults \

brew-itself: /usr/local/bin/brew
brew: \
	brew-itself \
	brew-baseline


/usr/local/bin/brew:
	$(BREW) doctor || sudo ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	$(BREW) analytics off

brew-baseline: brew-itself
	@$(BREW) update
	@export HOMEBREW_NO_AUTO_UPDATE=1
	# GNU coreutils instead of outdated mac os defaults
	-$(BREW) install coreutils moreutils
	# newer version of git
	$(BREW) install git
	# git-crypt for encrypted repository contents
	$(BREW) install git-crypt
	$(BREW) install jetbrains-toolbox 
	# install ripgrep, currently the fasted grep alternative
	$(BREW) install ripgrep
	# tree, a nice directory tree listing
	$(BREW) install tree
	# install readline, useful in combination with ruby-build because it will link ruby installations to it
	$(BREW) install readline
	# install direnv for project specific .envrc support
	$(BREW) install direnv
	# pipeviewer allows to display throughput/eta information on unix pipes
	$(BREW) install pv
	# pstree is nice to look at
	$(BREW) install pstree
	# watch is great for building an overview on running stuff
	$(BREW) install watch
	# sed, stream editor, but replace mac os version
	$(BREW) install gnu-sed
	# handle json on the command line
	$(BREW) install jq --HEAD
	$(BREW) install allure 
	$(BREW) install redis
	$(BREW) install xquartz
	$(BREW) install http-server
	$(BREW) tap kris-anderson/netperf
	$(BREW) install netperf-enable-demo
	$(BREW) install fping
	$(BREW) install gnuplot
	$(BREW) install libxml2 
	$(BREW) install gdb 
	$(BREW) install gcc 
	@$(BREW) update
	@export HOMEBREW_NO_AUTO_UPDATE=1
	# erlang programming language
	$(BREW) install erlang
	# elixir programming language
	$(BREW) install elixir
	# install and manage ruby versions
	$(BREW) install ruby-install
	# handle amazon web services related stuff
	$(BREW) install awscli
	$(BREW) install aws-iam-authenticator
	# tail cloudwatch logs (e.g. from Fargate containers)
	$(BREW) tap TylerBrock/saw
	$(BREW) install saw
	# handle google cloud related stuff
	$(CASK) install google-cloud-sdk
	# Google, you are fucking kidding me
	gcloud config set disable_usage_reporting false
	gcloud config set survey/disable_prompts True
	# neat way to expose a locally running service
	$(BREW) install cloudflare/cloudflare/cloudflared
	# smartmontools great for monitoring disks
	$(BREW) install smartmontools
	# I need to control kubernetes clusters
	$(BREW) install helm
	# Terraform, this is what makes the money
	$(BREW) install terraform
	# Kops is an alternative to EKS clusters (I no longer prefer)
	$(BREW) install kops
	# nmap is great for test and probing network related stuff
	$(BREW) install nmap
	# curl is a http development essential
	$(BREW) install curl
	# websocket client
	$(BREW) install websocat
	# vegeta is an insanely great http load tester and scalable http-client
	# hugo is my blogging engine
	$(BREW) install hugo
	$(BREW) install kubernetes-cli
	kubectl completion bash > $$HOME/dotfiles/.completion.d/kubectl
	pip3 install flent
	pip3 install pyqt5 qtpy

casks: \
	casks-baseline

casks-baseline: casks-itself
	@$(BREW) update
	@export HOMEBREW_NO_AUTO_UPDATE=1
	#$(CASK) install slate 
	# dropbox synchronised files across devices
	$(CASK) install dropbox
	# 1password is my password manager
	$(CASK) install lastpass 
	# Flux reduces blue/green colors on the display spectrum and helps me sleep better
	$(CASK) install flux
	$(BREW) install brave-browser 
	$(BREW) install goland
	$(BREW) install graphiql
	$(BREW) install notion
	$(BREW) install postman
	$(BREW) install pycharm-ce
	$(BREW) install slack
	$(BREW) install lens 
	$(BREW) install yarn 
	$(BREW) install watchman 
	$(BREW) install node 
	$(BREW) install awscli 
	$(BREW) install --cask raspberry-pi-imager 
	$(BREW) install --cask anaconda 
	$(BREW) install --cask windows-app 
	$(BREW) install openjdk 
	$(BREW) install zerotier-one 
	# tableplus is my preferred SQL-client
	$(CASK) install tableplus

bootstrap-fonts-directory:
	# Share user fonts via /usr/local
	chmod -a "group:everyone deny delete" ~/Library/Fonts || echo "No ACL present"
	rm -rf ~/Library/Fonts
	ls /usr/local/Fonts || sudo mkdir /usr/local/Fonts
	ln -svf /usr/local/Fonts ~/Library/Fonts

bash: brew-itself
	# newer version of bash
	$(BREW) install bash
	$(BREW) install bash-completion
	# change shell to homebrew bash
	grep /usr/local/bin/bash /etc/shells || (echo "/usr/local/bin/bash" | sudo tee -a /etc/shells)
	test "$$SHELL" = /usr/local/bin/bash || chsh -s /usr/local/bin/bash

ruby: \
	~/.rbenv \
	~/.rbenv/plugins/ruby-build \
	~/.rbenv/plugins/rbenv-update \
	~/.rbenv/plugins/rbenv-readline \
	~/.rbenv/plugins/rbenv-gemset

# rbenv is an amazing ruby version manager, simple, straightforward, local
~/.rbenv:
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
	cd ~/.rbenv && src/configure && make -C src

# ruby-build is a repository hosting all kinds of ruby versions to install
~/.rbenv/plugins/ruby-build:
	git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# rbenv-update allows updating rbenv plugins easily
~/.rbenv/plugins/rbenv-update:
	git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update

# rbenv-readline does the right thing when it comes to linking a brew installed readline to ruby
~/.rbenv/plugins/rbenv-readline:
	git clone git://github.com/tpope/rbenv-readline.git ~/.rbenv/plugins/rbenv-readline

# rbenv-gemset allows managing project specific set of gems
~/.rbenv/plugins/rbenv-gemset:
	git clone git://github.com/jf/rbenv-gemset.git ~/.rbenv/plugins/rbenv-gemset

vim: \
	vim-directories \
	vim-itself \
	vim-plugins

vim-directories:
	# create vim directories
	mkdir -p ~/.vim/tmp/{backup,swap,undo}
	chmod go= ~/.vim/tmp{,/*}

vim-itself: brew-itself
	# newer version of vim
	$(BREW) install vim

vim-plugins: \
	~/.vim/bundle/Vundle.vim
	# disable colorscheme for installing plugins to a temporary .vimrc
	sed 's/colorscheme/"colorscheme/' .vimrc > /tmp/.vimrc
	# install plugins with temporary vimrc
	vim -u /tmp/.vimrc +PluginInstall +qall
	-rm /tmp/.vimrc
	# post installation steps of command-t (use the ruby that ships with vim)
	cd ~/.vim/bundle/command-t/ruby/command-t/ext/command-t && make clean && export PATH="/usr/local/opt/ruby/bin:$$PATH" && ruby extconf.rb && make

# install vundle, a vim package manager
~/.vim/bundle/Vundle.vim:
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

tmux: \
	~/.tmux.conf
	$(BREW) install tmux
	$(BREW) install reattach-to-user-namespace

defaults: \
	defaults-NSGlobalDomain \
	# Show remaining battery time; hide percentage
	defaults write com.apple.menuextra.battery ShowPercent -string "NO"
	defaults write com.apple.menuextra.battery ShowTime -string "YES"
	# Enable AirDrop over Ethernet and on unsupported Macs running Lion
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
	# Automatically open a new Finder window when a volume is mounted
	defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
	defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
	# Avoid creating .DS_Store files on network volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	# Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
	# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
	# Check for software updates daily, not just once per week
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
	# Automatically illuminate built-in MacBook keyboard in low light
	defaults write com.apple.BezelServices kDim -bool true
	# Turn off keyboard illumination when computer is not used for 5 minutes
	defaults write com.apple.BezelServices kDimTime -int 300
	# Save screenshots to the desktop
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"
	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true
	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"
	# Hide all desktop icons because who needs them, I certainly don't
	defaults write com.apple.finder CreateDesktop -bool false
	# Finder: disable window animations and Get Info animations
	defaults write com.apple.finder DisableAllAnimations -bool true
	# Finder: show hidden files by default
	defaults write com.apple.Finder AppleShowAllFiles -bool true
	# Finder: show path bar
	defaults write com.apple.finder ShowPathbar -bool true
	# Empty Trash securely by default
	defaults write com.apple.finder EmptyTrashSecurely -bool false
	# Require password after 5 seconds on sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 5
	# Disable Game Center
	defaults write com.apple.gamed Disabled -bool true
	# Show the ~/Library folder
	chflags nohidden ~/Library
	# Keep this bit last
	# Kill affected applications
	for app in Safari Finder Mail SystemUIServer; do killall "$$app" >/dev/null 2>&1; done
	# Re-enable subpixel aliases that got disabled by default in Mojave
	defaults write -g CGFontRenderingFontSmoothingDisabled -bool false

defaults-NSGlobalDomain:
	# Locale
	defaults write NSGlobalDomain AppleLocale -string "en_US"
	defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
	defaults write NSGlobalDomain AppleMetricUnits -bool true
	# 24-Hour Time
	defaults write NSGlobalDomain AppleICUForce12HourTime -bool false
	# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
	# Enable subpixel font rendering on non-Apple LCDs
	defaults write NSGlobalDomain AppleFontSmoothing -int 2
	# Disable menu bar transparency
	defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
	# Enable press-and-hold for keys
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	# Set a blazingly fast keyboard repeat rate (1 = fastest for macOS high sierra, older versions support 0)
	defaults write NSGlobalDomain KeyRepeat -int 2
	# Decrase the time to initially trigger key repeat
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	# Enable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
	# Disable window animations
	defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
	# Increase window resize speed for Cocoa applications
	defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
	# Save to disk (not to iCloud) by default
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
	# Disable smart quotes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
	# Disable smart dashes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
	# Finder: show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

defaults-Trackpad:
	# Trackpad: enable tap to click for this user and for the login screen
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.trackpad.tapBehavior -int 1
	# Enable three-finger dragging
	defaults write NSGlobalDomain com.apple.driver.AppleBluetoothMultitouch.trackpad.TrackpadThreeFingerDrag -int 1
	# Make the trackpad fast
	defaults write NSGlobalDomain com.apple.mouse.scaling -float 10.0
	defaults write NSGlobalDomain com.apple.trackpad.scaling -float 10.0

dotfiles: \
	$(DOTFILES) \
	~/dotfiles

~/dotfiles:
	cd ~ && ln -svf $(DOTFILES_ROOT) dotfiles

~/.ssh/config:
	# Copy a default .ssh/config
	grep "Host *" ~/.ssh/config || mkdir ~/.ssh && cp $(DOTFILES_ROOT)/.ssh/config ~/.ssh/config

~/.gnupg:
	# Ask where to get .gnupg from
	@read -p "Where is .gnupg (from backup) located?" gnupg_source;
	cp -v $$gnupg_source ~/.gnupg

~/.%:
	cd ~ && ln -svf $(DOTFILES_ROOT)/$(notdir $@) $@

docker:
	$(CASK) install docker

zsh: /usr/local/bin/brew
	@# install oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
	$(BREW) install zsh-completions
	$(BREW) install zsh-syntax-highlighting
	$(BREW) install zsh-autosuggestions
	$(BREW) install autojump
	$(BREW) install powerlevel10k

taps: /usr/local/bin/brew
	brew tap colindean/fonts-nonfree
	brew tap cuelang/tap
	brew tap esolitos/ipa
	brew tap golangci/tap
	brew tap hashicorp/tap
	brew tap homebrew/core
	brew tap homebrew/services
	brew tap kudobuilder/tap
	brew tap liamg/tfsec
	brew tap mistertea/et
	brew tap octave-app/octave-app
	brew tap weaveworks/tap

java: /usr/local/bin/brew
	# JDK8
	$(BREW) install --cask adoptopenjdk8

golang: /usr/local/bin/brew
	# language
	$(BREW) install golang

fonts: \
	# tap homebrew-fonts to install freely available fonts
	#$(BREW) tap homebrew/cask-fonts
	# install Adobe Source Code Pro, an excellent mono space font for programming
	$(BREW) install font-hack-nerd-font
	$(BREW) install font-anonymice-nerd-font
	$(BREW) install font-victor-mono-nerd-font

gotools: golang
	# cleans up files with messy ascii codes
	go get github.com/lunixbochs/vtclean/vtclean
	go get github.com/nasuku/commandcast
	go get github.com/mattn/goreman

