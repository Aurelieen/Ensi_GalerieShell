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
        TEXTE_H1="Image sans titre"
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
    elif ! [ -f "$1" ];
    then
        (>&2 echo "** Erreur. Le fichier $1 n'existe pas.")
        exit 1
    fi

    # Génération de la balise d'image
    nom_fichier="$(basename "$1")"
    echo "<img src=\"${nom_fichier}\" title=\"${nom_fichier}\" alt=\"${nom_fichier}\" />"
}


# TODO. Fonction principale pour la génération des fichiers
# Arguments :   - TODO.
galerie_main() {
    echo "TODO."
}

# BASE TEMPORAIRE DE TESTS - A SUPPRIMER
# generate_img_fragment tests_perso/test1.jpg
# generate_img_fragment tests_perso/test8.png
