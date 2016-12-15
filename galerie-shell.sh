#! /bin/bash
# shellcheck source=utilities.sh

# INCLUSION DE FONCTIONS

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"//utilities.sh

# OK. --help/-h. Possibilités d'usage de la fonction
usage() {
    cat << EOF

Utilisation: $(basename "$0") [options]
Options :   --help          Afficher la liste des options
            --source REP    Choisir REP comme répertoire des images de départ.  Par défaut : actuel.
            --dest REP      Choisir REP comme répertoire cible de génération.   Par défaut : /dest.
            --verb          Détailler les commandes du script
            --force         Regénérer les vignettes existantes
            --index FICHIER Générer la galerie dans un fichier "FICHIER.html".  Par défaut : index.html.
            --parallel NB   Paralléliser la création de NB vignettes à la fois. Par défaut : 4.

EOF
}

# TODO. Fonction principale qui redirige le résultat des arguments
arguments_main() {
    NOM_INDEX="index.html"
    PARALLELES="4"
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
            "--parallel")
                PARALLELES="$2"
                shift;
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

    if [ "$NOM_SOURCE" != "" ];
    then
        NOM_SOURCE=$(pwd)/"$NOM_SOURCE"     # Rendre absolu le chemin source
    fi

    # Intégrité des arguments
    verifier_index      "$NOM_INDEX"        # Nom de l'index HTML
    verifier_source     "$NOM_SOURCE"       # Nom du répertoire source
    verifier_dest       "$NOM_DEST"         # Nom du répertoire de destination
    verifier_parallele  "$PARALLELES"       # Nombre de parallélisations

    # Présence des arguments par défaut
    if [ "$NOM_DEST" = "" ];
    then
        NOM_DEST="$(pwd)/dest"              # Rendre absolue la destination vide
    fi

    if [ "$NOM_SOURCE" = "" ];
    then
        NOM_SOURCE="$(pwd)"                 # Rendre absolu la source . (vide)
    fi

    # Génération des fichiers dans utilities.sh
    galerie_main "$NOM_INDEX" "$NOM_SOURCE" "$NOM_DEST" \
                 "$IS_VERBOSE" "$IS_FORCING" \
                 "$PARALLELES"
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
        echo "** Note. Le répertoire source par défaut est le répertoire actuel ($(pwd))."
    elif [ ! -d "$1" ];
    then
        (>&2 echo "** Erreur. Ce répertoire source n'existe pas : $1")
        usage
        exit 1
    else
        # Une source valide est 'r' et 'x' au minimum pour l'utilisateur.
        permissions="$(stat -c %A "$1")"
        permissions="${permissions:1:3}"

        if [[ ! "$permissions" == r*x ]];
        then
            (>&2 echo "** Erreur. Les permissions sont insuffisantes pour la source : $1 ($(stat -c %A "$1"))")
            usage
            exit 1
        fi
    fi

    repertoire=${1:-.}
    nb_fichiers_jpg="$(find "$repertoire" -maxdepth 1 -mindepth 1 -type f -name "*.jpg" -exec printf x \; | wc -c)"
    if [ "$nb_fichiers_jpg" -eq 0 ];
    then
        (>&2 echo "** Note. La source ne contient aucun fichier .JPG. La commande est sans effet.")
        usage
        exit 1
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
        if [ ! -d dest ];
        then
            mkdir -p dest
        fi

        chmod 755 dest
        echo "** Note. Le répertoire cible par défaut est /dest."
    else
        # Une destination valide est 'rwx' au minimum pour l'utilisateur.
        permissions="$(stat -c %A "$1")"
        permissions="${permissions:1:3}"

        if [[ ! "$permissions" == rwx ]];
        then
            (>&2 echo "** Erreur. Les permissions sont insuffisantes pour la destination : $1 ($(stat -c %A "$1"))")
            usage
            exit 1
        fi
    fi
}

# TODO. Vérifier que le nombre de parallélisations simultanées est correct.
# Arguments :   - Le nombre PARALLELES demandé par l'utilisateur
verifier_parallele() {
    # C'est un entier
    case "$PARALLELES" in
        ''|*[!0-9]*)
            (>&2 echo "** Erreur. Le nombre $PARALLELES de vignettes à paralléliser n'est pas entier.")
            usage; exit 1
            ;;
    esac

    if [ "$PARALLELES" -lt 1 ] || [ "$PARALLELES" -gt 10 ];
    then
        (>&2 echo "** Erreur. Le nombre ($PARALLELES) de vignettes à paralléliser doit être compris entre 1 et 4.")
        usage
        exit 1
    fi
}

arguments_main "$@"         # Main de galerie-shell.sh pour traiter les arguments
