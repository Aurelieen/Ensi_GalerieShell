#! /bin/sh

# OK. --help/-h. Possibilités d'usage de la fonction
usage() {
    cat << EOF

Utilisation: $(basename "$0") [options]
Options :   --help          Afficher la liste des options
            --source REP    Choisir REP comme répertoire des images de départ
            --dest REP      Choisir REP comme répertoire cible de génération
            --verb          Détailler les commandes du script
            --force         Regénérer les vignettes existantes
            --index FICHIER Générer la galerie dans un fichier "FICHIER.html"

EOF
}

# TODO. Fonction principale qui redirige le résultat des arguments
galerie_main() {
    while [ "$#" -ne 0 ];
    do
        case "$1" in
            "--help" | "-h")
                usage
                exit 0
                ;;
            "--index")
                NOM_INDEX="$2"
                shift;
                ;;
            "--source")
                NOM_SOURCE="$2"
                shift;
                ;;
            "--dest")
                NOM_DEST="$2"
                shift;
                ;;
            "--verb")
                IS_VERB=YES
                ;;
            "--force")
                IS_FORCE=YES
                ;;
            *)
                (>&2 echo "** Erreur. Argument non reconnu : $1")
                usage
                exit 1
                ;;
        esac
        shift
    done

    echo "NOM_INDEX : $NOM_INDEX"
    echo "NOM_SOURCE : $NOM_SOURCE"
    echo "NOM_DEST : $NOM_DEST"
    echo "IS_VERB : $IS_VERB"
    echo "IS_FORCE : $IS_FORCE"
}


# Fonctions de vérification des arguments
#########################################

# TODO. Vérifier que le nom voulu en index est correctement formaté.
# Arguments :   - Le nom du fichier index


galerie_main "$@"
