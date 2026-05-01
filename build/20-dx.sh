#!/usr/bin/bash

set -eoux pipefail

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

# Enable nullglob for all glob operations to prevent failures on empty matches
shopt -s nullglob

echo "::group:: Installing DX Packages from Fedora repos"

# DX packages from Fedora repos - common to all versions
FEDORA_PACKAGES=(
	android-tools
	bcc
	bpftop
	bpftrace
	cascadia-code-fonts
	clang
	dbus-x11
	dnf-plugins-core
	edk2-ovmf
	flatpak-builder
	genisoimage
	git
	git-subtree
	git-svn
	gum
	golang-bin
	iotop
	libvirt
	libvirt-nss
	make
	nicstat
	numactl
	osbuild-selinux
	p7zip
	p7zip-plugins
	podman-compose
	podman-machine
	qemu
	qemu-char-spice
	qemu-device-display-virtio-gpu
	qemu-device-display-virtio-vga
	qemu-device-usb-redirect
	qemu-img
	qemu-system-x86-core
	qemu-user-binfmt
	qemu-user-static
	sysprof
	lxc
	tiptop
	trace-cmd
	udica
	util-linux-script
	virt-manager
	virt-v2v
	virt-viewer
	ydotool
	rocm-hip
	rocm-opencl
	rocm-smi
)

echo "Installing ${#FEDORA_PACKAGES[@]} DX packages from Fedora repos..."
dnf5 -y install "${FEDORA_PACKAGES[@]}"

# Docker repository
dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
dnf5 -y install --enablerepo=docker-ce-stable \
	containerd.io \
	docker-buildx-plugin \
	docker-ce \
	docker-ce-cli \
	docker-compose-plugin \
	docker-model-plugin

# VS Code repository
tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/vscode.repo
dnf5 -y install --enablerepo=code \
	code

# DX packages to exclude - common to all versions
EXCLUDED_PACKAGES=()

# Remove excluded packages if they are installed
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
	readarray -t INSTALLED_EXCLUDED < <(rpm -qa --queryformat='%{NAME}\n' "${EXCLUDED_PACKAGES[@]}" 2>/dev/null || true)
	if [[ "${#INSTALLED_EXCLUDED[@]}" -gt 0 ]]; then
		dnf5 -y remove "${INSTALLED_EXCLUDED[@]}"
	else
		echo "No excluded packages found to remove."
	fi
fi

systemctl enable docker.socket
systemctl enable podman.socket
systemctl enable swtpm-workaround.service
systemctl enable libvirt-workaround.service
systemctl enable neptuno-groups.service

echo "::endgroup::"

# Restore default glob behavior
shopt -u nullglob

echo "DX build complete!"
