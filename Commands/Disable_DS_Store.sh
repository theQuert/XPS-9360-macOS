sudo find / -name ".DS_Store" -depth -exec rm {} \; && defaults write com.apple.desktopservices DSDontWriteNetworkStores true
