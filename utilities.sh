#! /bin/sh

# OK. Renvoie l'en-tête d'un fichier HTML
# Arguments :   - Titre de la page
html_head () {
    if [ "$#" -eq 0 ];
    then
        TITRE_PAGE="Galerie d'images (TPL)"
    else
        TITRE_PAGE="$1"
    fi

cat <<- EOM
<!doctype html>
<html>
    <head>
        <meta charset="utf8">
        <title>${TITRE_PAGE}</title>
    </head>
    <body>
EOM
}

# OK. Renvoie un titre de niveau 1 en HTML
# Arguments :   - Texte à titrer
html_title () {
    if [ "$#" -eq 0 ];
    then
        TEXTE_H1="Galerie d'images"
    else
        TEXTE_H1="$1"
    fi

    echo "<h1>${TEXTE_H1}</h1>"
}

# OK. Renvoie la fin du document HTML
# Arguments :   AUCUN.
html_tail () {
cat <<- EOM
        <!-- Pied de page du document HTML. -->
    </body>
</html>
EOM
}

# OK. Renvoie une balise <img> en HTML
# Arguments :   - Chemin vers une image
generate_img_fragment() {
    if [ "$#" -eq 0 ];
    then
        (>&2 echo "** Erreur. Aucun fichier transmis en entrée.")
        exit 1
    elif [ "${1: -4}" != ".jpg" ];
    then
        (>&2 echo "** Erreur. L'image $1 n'est pas au format .jpg.")
        exit 1
    elif [ ! -f "$1" ];
    then
        (>&2 echo "** Erreur. Le fichier $1 n'existe pas.")
        exit 1
    fi

    # Génération de la balise d'image
    nom_fichier="$(basename "$1")"
    date_fichier="$(identify -format %[EXIF:DateTime] "$img")"

    if [ "$date_fichier" = "" ];
    then
        date_fichier="<span class=\"nodate\">Pas de date disponible.</span>"
    fi

    cat <<- EOM
        <figure>
            <img src="${nom_fichier}" title="${nom_fichier}" alt="${nom_fichier}" />
            <figcaption>${nom_fichier/vignette_/} $date_fichier</figcaption>
        </figure>
EOM
}

# TODO. Crée les vignettes qui n'existent pas déjà à partir des images sources
# Arguments :   - dossier SOURCE, dossier DEST
generate_vignette() {
    generate_parallel_vignette "${NOM_SOURCE}"
    return

    for img in "${NOM_SOURCE}"/*.jpg;
    do
        # Si la vignette n'existe pas déjà dans le répertoire cible...
        NOM_VIGNETTE="${NOM_DEST}/vignette_$(basename $img)"

        # Se prémunir des fausses images et du jeton *
        if [ ! -f "$img" ];
        then
            break
        fi

        # Génération de la vignette
        if [ "$IS_FORCING" = true ];
        then
            img_to_vignette "$img" "$NOM_VIGNETTE"
            au_moins_une_generation=true

            generate_img_fragment "$NOM_VIGNETTE" "$img" >> "$NOM_INDEX"
            echo "*** [Mode Force] La vignette $(basename $NOM_VIGNETTE) a bien été générée."
        else
            if [ ! -f "$NOM_VIGNETTE" ];
            then
                img_to_vignette "$img" "$NOM_VIGNETTE"
                au_moins_une_generation=true

                generate_img_fragment "$NOM_VIGNETTE" "$img" >> "$NOM_INDEX"
                echo "*** La vignette $(basename $NOM_VIGNETTE) a bien été générée."
            else
                # TODO. Améliorer la sortie et créer une barre de chargement.
                echo ">> $img. Génération impossible, vignette existante."
            fi
        fi
    done

    # Avertissement en cas d'absence de vignettes nouvelles.
    if [ ! "$au_moins_une_generation" = true ];
    then
        (>&2 echo "")
        (>&2 echo "** Note. Aucune vignette n'a pu être générée.")
    fi
}


# TODO. Version parallèle pour la génération des vignettes.
# Arguments :   - TODO.
generate_parallel_vignette() {
    # Exports des fonctions, impossible d'utiliser `xargs` sinon
    export -f generate_img_fragment
    export -f img_to_vignette
    export -f parallel_img_to_vignette

    # Génération de la commande parallèle
    # INFORMATIONS. Les noms des fichiers renvoyés par `find` sont
    # interprétés un par un et passés comme dernier argument.
    find "${NOM_SOURCE}" -maxdepth 1 -name "*.jpg" -print0 | xargs -0 -n 1 -P 8 \
        bash -c 'parallel_img_to_vignette "$0" "$1" "$2" "$3" "$4"' \
        "${NOM_SOURCE}" "${NOM_DEST}" "${NOM_INDEX}" "${IS_FORCING}"

    # COMMENTAIRES. Par rapport à la fonction generate_vignette, la majorité
    # des traitements sont délégués à parallel_img_to_vignette
}


# TODO. Version parallèle de l'image à la vignette.
# Arguments :   - TODO.
parallel_img_to_vignette() {
    NOM_SOURCE="$1"
    NOM_DEST="$2"
    NOM_INDEX="$3"
    IS_FORCING="$4"
    img="$5"                         # Attention, paramètre délégué en dernier !

    # echo "$@"
    # echo "$1 $2 $3 $4"

    # Prévention des images qui n'en sont pas
    if [ ! -f "$img" ];
    then
        return
    fi

    NOM_VIGNETTE="${NOM_DEST}/vignette_$(basename $img)"

    # Génération du code HTML et de la vignette
    if [ "$IS_FORCING" = true ];
    then
        img_to_vignette "$img" "$NOM_VIGNETTE"
        # au_moins_une_generation=true

        generate_img_fragment "$NOM_VIGNETTE" "$img" >> "$NOM_INDEX"
        echo "*** [Mode Force] La vignette $(basename $NOM_VIGNETTE) a bien été générée."
    else
        if [ ! -f "$NOM_VIGNETTE" ];
        then
            img_to_vignette "$img" "$NOM_VIGNETTE"
            # au_moins_une_generation=true

            generate_img_fragment "$NOM_VIGNETTE" "$img" >> "$NOM_INDEX"
            echo "*** La vignette $(basename $NOM_VIGNETTE) a bien été générée."
        else
            # TODO. Améliorer la sortie et créer une barre de chargement.
            echo ">> $img. Génération impossible, vignette existante."
        fi
    fi
}


# TODO. Associe la création d'une vignette à une commande gmic
# Arguments :   - Nom de l'image, nom de la vignette, [OPTIONS GMIC]
img_to_vignette() {
    gmic "$img" -cubism , -resize 200,200 -output "$NOM_VIGNETTE" 2> /dev/null
}


# TODO. Crée le fichier .HTML à partir des vignettes générées avant
# Arguments :   - Nom de l'index, dossier DEST
generate_html() {
    NOM_INDEX="${NOM_DEST}/${NOM_INDEX}"

    # Suppression de l'ancien fichier
    if [ -f "$NOM_INDEX" ];
    then
        rm "$NOM_INDEX"
    fi

    # 1. Ecrire le nouveau fichier : en-tête
    html_head > "$NOM_INDEX"
    html_title >> "$NOM_INDEX"

    # 2. Génération des vignettes et de leur légende
    generate_vignette "$NOM_SOURCE" "$NOM_DEST" "$IS_FORCING" "$NOM_INDEX"

    # 3. Ecrire le nouveau fichier : pied-de-page
    html_tail >> "$NOM_INDEX"

    echo ''
    echo "-- Fin de la génération --"
    echo "-- firefox ${NOM_INDEX} pour voir le résultat. --"
}

# TODO. Fonction principale pour la génération des fichiers
# Arguments :   - TODO.
galerie_main() {
    NOM_INDEX="$1"
    NOM_SOURCE="$2"
    NOM_DEST="$3"

    IS_VERBOSE="$4"
    IS_FORCING="$5"

    # Génération du fichier HTML et des vignettes
    generate_html "$NOM_INDEX" "$NOM_DEST" "$IS_FORCING"
}
