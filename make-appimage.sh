#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q diffpdf | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/64x64/apps/diffpdf.png
export DESKTOP=/usr/share/applications/eu.qtrac.diffpdf.desktop
export STARTUPWMCLASS=DiffPDF
export DEPLOY_QT=1
export QT_DIR=qt5
export ALWAYS_SOFTWARE=1

# on archlinux qt5-wayland also adds the server side plugins
# remove them so that they do not get deployed
rm -rf /usr/lib/qt/plugins/wayland-graphics-integration-server

# Deploy dependencies
quick-sharun /usr/bin/diffpdf

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
