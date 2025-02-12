#!/bin/bash

echo "CleanerTool - Version macOS v3.2 - Nettoyage Approfondi"
echo "========================================================="

# Vérification des droits d'administration
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script avec sudo."
    exit 1
fi

# Fonction de confirmation
confirmation() {
    read -p "Voulez-vous vraiment lancer le nettoyage approfondi du système macOS ? (O/N): " response
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

    # Suppression des fichiers temporaires dans /tmp et /var/tmp
    temp_dirs=("/tmp" "/var/tmp")
    for dir in "${temp_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "Suppression du contenu de $dir..."
            rm -rf "$dir"/*
        fi
    done

    # Nettoyage du cache d'applications dans le dossier Library
    if [ -d "$HOME/Library/Caches" ]; then
        echo "Nettoyage des caches des applications (~/Library/Caches)..."
        rm -rf "$HOME/Library/Caches"/*
    fi

    # Nettoyage des logs utilisateurs
    if [ -d "$HOME/Library/Logs" ]; then
        echo "Nettoyage des logs utilisateurs (~/Library/Logs)..."
        rm -rf "$HOME/Library/Logs"/*
    fi

    # Suppression des rapports de plantage
    if [ -d "$HOME/Library/Logs/DiagnosticReports" ]; then
        echo "Nettoyage des rapports de plantage..."
        rm -rf "$HOME/Library/Logs/DiagnosticReports"/*
    fi

    # Exécution des scripts de maintenance périodique de macOS
    echo "Exécution des scripts de maintenance (daily, weekly, monthly)..."
    periodic daily weekly monthly

    # Nettoyage de la corbeille de l'utilisateur
    if [ -d "$HOME/.Trash" ]; then
        echo "Vider la corbeille de l'utilisateur..."
        rm -rf "$HOME/.Trash"/*
    fi

    echo "Nettoyage terminé."
    exit 0
}

# Demande de confirmation
confirmation