#!/usr/bin/env bash
mkdir ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots; killall SystemUIServer
