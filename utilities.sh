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

# TODO. Renvoie la fin du document HTML
# Arguments :   AUCUN.
html_tail () {
    cat <<- EOM
                <!-- Pied de page du document HTML. -->
            </body>
        </html>
EOM
}

html_tail
