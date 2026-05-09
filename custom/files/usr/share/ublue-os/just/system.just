# vim: set ft=make :
# This file should only contain bluefin specific stuff

# Configure Bluefin-CLI Terminal Experience with Brew
[group('System')]
neptuno-cli:
    @ublue-bling
    brew bundle --file=/usr/share/ublue-os/homebrew/cli.Brewfile

# Install system flatpaks for rebasers
[group('System')]
install-system-flatpaks $confirm="1" $dx_only="0":
    #!/usr/bin/env bash
    if [[ "$(jq '."image-flavor"' /usr/share/ublue-os/image-info.json)" =~ dx ]] ; then
        ADD_DEVMODE="${ADD_DEVMODE:-1}"
    fi
    if [ "${ADD_DEVMODE:-0}" == "1" ] ; then
        if [ "$confirm" != 0 ] ; then
            gum confirm "Install development flatpaks?" || exit 0
        fi
        brew bundle --file="${TARGET_FLATPAK_FILE:-/usr/share/ublue-os/homebrew/system-dx-flatpaks.Brewfile}"
    fi
    [ "$dx_only" == 1 ] && exit 0
    if [ "$confirm" != 0 ] ; then
        gum confirm "Install system flatpaks?" || exit 0
    fi
    brew bundle --file="${TARGET_FLATPAK_FILE:-/usr/share/ublue-os/homebrew/system-flatpaks.Brewfile}"

# Install default system flatpaks (alias for install-system-flatpaks)
# For additional applications, use: ujust bbrew
[group('System')]
bluefin-apps:
    echo "Installing default system flatpaks..."
    @ujust install-system-flatpaks

alias switch-stream := rebase-helper
alias switch-streams := rebase-helper
alias rollback-helper := rebase-helper

# Rebase assistant

# Factory reset this device (experimental)
[group('System')]
powerwash:
    #!/usr/bin/bash
    FIRST_CONFIRMATION=$(gum choose --header='Warning: This is an experimental feature that will reset this device to its factory state.' "No" "Yes - wipe this machine")
    if [[ "$FIRST_CONFIRMATION" != "Yes - wipe this machine" ]]; then
        echo "Powerwash cancelled."
        exit 0
    fi
    SECOND_CONFIRMATION=$(gum choose --header='Are you sure?' "No" "Yes - wipe this machine")
    if [[ "$SECOND_CONFIRMATION" != "Yes - wipe this machine" ]]; then
        echo "Powerwash cancelled."
        exit 0
    fi
    sudo bootc install reset --experimental
