#! /bin/sh

# INCLUSION DE FONCTIONS
DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"//utilities.sh

# OK. --help/-h. Possibilités d'usage de la fonction
usage() {
    cat << EOF

Utilisation: $(basename "$0") [options]
Options :   --help          Afficher la liste des options
            --source REP    Choisir REP comme répertoire des images de départ
            --dest REP      Choisir REP comme répertoire cible de génération.   Par défaut : /dest.
            --verb          Détailler les commandes du script
            --force         Regénérer les vignettes existantes
            --index FICHIER Générer la galerie dans un fichier "FICHIER.html".  Par défaut : index.html.

EOF
}

# TODO. Fonction principale qui redirige le résultat des arguments
arguments_main() {
    NOM_INDEX="index.html"
    IS_VERBOSE=false
    IS_FORCING=false

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
                IS_VERBOSE=true
                ;;
            "--force")
                IS_FORCING=true
                ;;
            *)
                (>&2 echo "** Erreur. Argument non reconnu : $1")
                usage
                exit 1
                ;;
        esac
        shift
    done

    # Présence minimale des arguments
    if [ "$NOM_DEST" != "" ];
    then
        NOM_DEST=$(pwd)/"$NOM_DEST"         # Rendre absolue la destination
    fi

    NOM_SOURCE=$(pwd)/"$NOM_SOURCE"         # Rendre absolu le chemin source

    # Intégrité des arguments
    verifier_index  "$NOM_INDEX"            # Nom de l'index HTML
    verifier_source "$NOM_SOURCE"           # Nom du répertoire source
    verifier_dest   "$NOM_DEST"             # Nom du répertoire de destination

    if [ "$NOM_DEST" = "" ];
    then
        NOM_DEST="$(pwd)/dest"              # Rendre absolue la destination vide
    fi

    # echo "$NOM_INDEX" "$NOM_SOURCE" "$NOM_DEST"
    galerie_main "$NOM_INDEX" "$NOM_SOURCE" "$NOM_DEST"         # Main de utilities.sh pour la génération HTML
}


# Fonctions de vérification des arguments
#########################################

# TODO. Vérifier que le nom voulu en index est correctement formaté.
# Arguments :   - Le nom du fichier index
verifier_index() {
    if [ "$1" = "" ] || [ "${1: -5}" != ".html" ];
    then
        (>&2 echo "** Erreur. Nom de fichier index incorrect.")
        usage
        exit 1
    fi
}

# TODO. Vérifier que le nom du répertoire source existe.
# Arguments :   - Le nom du répertoire demandé
verifier_source() {
    if [ "$1" = "" ];
    then
        (>&2 echo "** Erreur. Aucun répertoire source spécifié.")
        usage
        exit 1
    elif [ ! -d "$1" ];
    then
        (>&2 echo "** Erreur. Ce répertoire source n'existe pas : $1")
        usage
        exit 1
    else
        # TODO. Droits.
        echo "TODO. Vérifier les droits de lecture/exec source"
    fi
}

# TODO. Vérifier que le répertoire de destination existe, sinon le créer.
# Arguments :   - Le nom du répertoire demandé
verifier_dest() {
    if [ "$1" != "" ] && [ ! -d "$1" ];
    then
        mkdir -p "$1"
        chmod 755 "$1"
        echo "** Note. Le répertoire cible $1 a été créé car il n'existait pas."
    elif [ "$1" = "" ];
    then
        rm -fr dest
        mkdir -p dest
        chmod 755 dest
    else
        # TODO. Droits.
        echo "TODO. Vérifier les droits d'écriture/lecture/exec dest"
    fi
}

arguments_main "$@"         # Main de galerie-shell.sh pour traiter les arguments
