#!/bin/bash

echo "CleanerTool - Version Linux v3.2 - Nettoyage Approfondi"
echo "========================================================="

# Vérification des droits d'administration
if [ "$EUID" -ne 0 ]; then
    echo "Vous devez exécuter ce script en tant qu'administrateur (root)."
    exit 1
fi

# Fonction de confirmation
confirmation() {
    read -p "Voulez-vous vraiment lancer le nettoyage approfondi du système Linux ? (O/N): " response
    case "$response" in
        [oO]|[oO][uU][iI]|[yY])
            cleanup
            ;;
        *)
            echo "Annulation de l'opération."
            exit 0
            ;;
    esac
}

# Fonction de nettoyage
cleanup() {
    echo "Nettoyage en cours..."

    # Suppression des répertoires de fichiers temporaires
    temp_dirs=("/tmp" "/var/tmp" "/usr/tmp" "/private/var/tmp")
    for dir in "${temp_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "Suppression du contenu de $dir..."
            rm -rf "$dir"/*
        fi
    done

    # Nettoyage du cache du gestionnaire de paquets (Debian/Ubuntu)
    if command -v apt-get &>/dev/null; then
        echo "Nettoyage du cache APT..."
        apt-get clean
    fi

    # Nettoyage du cache pour les systèmes basés sur Pacman (Arch)
    if command -v pacman &>/dev/null; then
        echo "Nettoyage du cache Pacman..."
        pacman -Scc --noconfirm
    fi

    # Nettoyage du cache pour DNF (Fedora, CentOS)
    if command -v dnf &>/dev/null; then
        echo "Nettoyage du cache DNF..."
        dnf clean all
    fi

    # Réinitialisation (troncature) des fichiers de logs dans /var/log
    if [ -d "/var/log" ]; then
        echo "Troncature des fichiers de logs dans /var/log..."
        find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;
    fi

    # Nettoyage du cache des miniatures pour l'utilisateur courant
    if [ -d "$HOME/.cache/thumbnails" ]; then
        echo "Nettoyage du cache des miniatures..."
        rm -rf "$HOME/.cache/thumbnails"/*
    fi

    # Nettoyage de la corbeille de l'utilisateur courant
    if [ -d "$HOME/.local/share/Trash/files" ]; then
        echo "Nettoyage de la corbeille de l'utilisateur..."
        rm -rf "$HOME/.local/share/Trash/files"/*
    fi

    # Nettoyage des journaux systemd (vacuum pour conserver 1 mois de logs)
    if command -v journalctl &>/dev/null; then
        echo "Nettoyage des journaux systemd (vacuum à 1 mois)..."
        journalctl --vacuum-time=1month
    fi

    echo "Nettoyage terminé."
    exit 0
}

# Demande de confirmation
confirmation