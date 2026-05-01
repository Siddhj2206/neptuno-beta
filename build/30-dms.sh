#!/usr/bin/bash

set -eoux pipefail

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

# Enable nullglob for all glob operations to prevent failures on empty matches
shopt -s nullglob

echo "::group:: Install DMS"

# Enable COPR repos
dnf5 copr enable -y avengemedia/danklinux
dnf5 copr enable -y avengemedia/dms
dnf5 copr enable -y yalter/niri

# Install supporting packages
dnf5 install -y \
    xdg-desktop-portal-gtk \
    accountsservice \
    xwayland-satellite \
    adw-gtk3-theme \
    qt6ct \
    qt6-qtmultimedia \
    qt6-qtimageformats \
    cliphist \
    wl-clipboard

# Install DMS stack with weak dependencies disabled
dnf5 install -y --setopt=install_weak_deps=False \
    niri \
    quickshell \
    matugen \
    dgop \
    dsearch \
    cava \
    khal \
    ghostty \
    dms

# Disable COPR repos
dnf5 copr disable -y avengemedia/danklinux
dnf5 copr disable -y avengemedia/dms
dnf5 copr disable -y yalter/niri

# Wire DMS user service to niri session
systemctl --global add-wants niri.service dms
systemctl --global enable dsearch

echo "::endgroup::"

# Restore default glob behavior
shopt -u nullglob

echo "DMS build complete!"
echo "After booting, select the Niri session at the login screen and run 'ujust dms-doctor' to validate the setup"
