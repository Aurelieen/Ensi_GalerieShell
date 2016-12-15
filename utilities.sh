#! /bin/sh
# shellcheck disable=SC2039

# TODO. Ecrit l'information passée en paramètre si le mode verbeux est activé.
# Arguments :   - IS_VERBOSE, Message à diffuser
echo_verbose() {
    if [ "$IS_VERBOSE" = true ] && [ "$#" -eq 2 ];
    then
        echo "$2"
    fi
}


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
        <meta charset="utf-8">
        <title>${TITRE_PAGE}</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                font-size: 62.5%;
                background: #EEE;
            }

            main {
                width: 90%;
                margin: auto;
                text-align: center;
            }

            h1 {
                width: 100%;
                text-align: center;
                font-size: 3.2em;

                font-family: cursive;
                margin-bottom: 30px;
            }

            figure {
                width: 300px !important;
                height: 300px !important;
                position: relative;

                display: inline-block;
                text-align: center;

                border: 2px solid #BBB;
                padding: 0;
                margin: 0;

                cursor: pointer;
                background-size: cover !important;
            }

            figure::before {
                content: "";
                height: 100%;
                width: 100%;

                top: 0;
                left: 0;

                cursor: pointer;
                position: absolute;
                transition: background 0.4s;
            }

            figure:hover {
                border: 2px solid rgb(188, 100, 37);
                transition: border 0.2s;
            }

            figure:hover::before {
                content: "";
                background: rgba(188, 100, 37, 0.6);
                width: 100%;
                height: 100%;
            }

            figcaption {
                display: table;
                position: absolute;
                height: 300px !important;
                width: 300px !important;

                opacity: 0;
                transition: opacity 0.5s;
                z-index: 2;
            }

            figcaption > a {
                display: table;
                height: 300px;
                left: 0;
                position: absolute;
                top: 0;
                width: 300px;

                text-decoration: none;
            }

            figcaption > a div {
                display: table-cell;
                vertical-align: middle;
                width: 100%;

                font-size: 1.5em !important;
                font-family: "Tahoma", sans-serif;
            }

            figcaption > a div .legend {
                display: block;
                margin: auto;
                width: 70%;
                margin-bottom: 25px;

                font-weight: bold;
                color: white;
                word-wrap: break-word;
            }

            figcaption > a div .nodate {
                background: red;
                padding: 3px;
                border-radius: 3px;
                color: white;
            }

            figcaption > a div .date {
                background: white;
                padding: 3px;
                border-radius: 3px;
                color: black;
            }

            figure:hover figcaption {
                opacity: 1;
            }

            /* PLEINES PAGES */
            nav {
                margin-bottom: 15px;
            }

            .img_page {
                max-width: 100%;
                border: 2px solid #AAA;
            }

            a.link {
                display: inline-block;
                font-size: 1.5em;
                width: 120px;

                appearance: button;
                -moz-appearance: button;
                -webkit-appearance: button;

                text-decoration: none;
                color: black;
                text-transform: uppercase;
            }

            a.nolink {
                display: inline-block;
                font-size: 1.5em;
                width: 120px;

                appearance: button;
                -moz-appearance: button;
                -webkit-appearance: button;

                text-decoration: none;
                pointer-events: none;
                cursor: default;
                color: #AAAAAA;
                text-transform: uppercase;
            }

            p#validator {
                display: block;
                width: 80%;
                margin: auto;
                text-align: center;

                font-size: 1.5em;
                color: #999;
                margin-top: 15px;
            }
        </style>
    </head>
    <body>
        <main>
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

# TODO. Renvoie une image et deux boutons de navigation.
# Arguments :   -
html_image_and_buttons () {
    echo "<nav>"

    # Ajout du bouton PRECEDENT
    if [ "${fichier_precedent}" = "" ];
    then
        echo "<a href=\"\" class=\"nolink\">Précédent</a>"
    else
        echo "<a href=\"${fichier_precedent}\" class=\"link\">Précédent</a>"
    fi

    fichier_index="$(basename "${NOM_INDEX}")"
    echo "<a href=\"../${fichier_index}\" class=\"link\" style=\"width: 200px;\">Retour à l'index</a>"

    # Ajout du bouton SUIVANT
    if [ "${fichier_suivant}" = "" ];
    then
        echo "<a href=\"\" class=\"nolink\">Suivant</a>"
    else
        echo "<a href=\"${fichier_suivant}\" class=\"link\">Suivant</a>"
    fi

    echo "</nav>"

    # Ajout de l'image et des attributs pour l'accessibilité
    echo "<img class=\"img_page\" src=\"../sources/${fichier_nom}\" alt=\"${fichier_nom}\" title=\"${fichier_nom}\" />"
}

# OK. Renvoie la fin du document HTML
# Arguments :   AUCUN.
html_tail () {
cat <<- EOM
        <!-- Pied de page du document HTML. -->
        </main>
        <footer>
            <p id="validator">Le code HTML de ce document est conforme aux spécifications de HTML5. Il a été testé grâce au service de validation du W3C.</p>
        </footer>
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
    else
        date_fichier="<span class=\"date\">${date_fichier}</span>"
    fi

    # CSS utilise le backslash pour échapper les caractères
    # On procède aux remplacements sur le nom du fichier
    safe_fichier="${nom_fichier/vignette_/}"
    safe_fichier="${nom_fichier//\\/__bslash__}"
    safe_fichier_css="${safe_fichier//\'/\'}"

    cat <<- EOM
        <figure style="background: url('${safe_fichier_css}');">
            <figcaption>
                <a href="pages/${safe_fichier%.*}.html" title="Ouvrir l'image en pleine page">
                    <div>
                        <span class="legend">${safe_fichier}</span>${date_fichier}
                    </div>
                </a>
            </figcaption>
        </figure>
EOM
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
    find "${NOM_SOURCE}" -maxdepth 1 -name "*.jpg" -print0 | xargs -0 -n 1 -P "${PARALLELES}" \
        bash -c 'parallel_img_to_vignette "$0" "$1" "$2" "$3" "$4"' \
        "${NOM_SOURCE}" "${NOM_DEST}" "${NOM_INDEX}" "${IS_FORCING}"

    # Quand les vignettes sont générées, on génère les pages uniques.
    # Trois variables pour l'image actuelle, l'image qui la précéde et celle qui suit.
    mkdir -p "${NOM_DEST}/sources"
    mkdir -p "${NOM_DEST}/pages"

    img_precedent=
    img_actuel=

    for img in "${NOM_DEST}"/*.jpg;
    do
        if [ ! -f "$img" ];
        then
            break
        fi

        img_precedent="$img_actuel"
        img_actuel="$img_suivant"
        img_suivant="$img"

        if [ "$img_actuel" != "" ];
        then
            generate_html_page "$NOM_DEST" "$img_precedent" "$img_actuel" "$img_suivant" "$NOM_SOURCE" "$NOM_INDEX"
        fi
    done

    img_precedent="$img_actuel"
    img_actuel="$img_suivant"
    img_suivant=""

    generate_html_page "$NOM_DEST" "$img_precedent" "$img_actuel" "$img_suivant" "$NOM_SOURCE" "$NOM_INDEX"
}


# TODO. Version parallèle de l'image à la vignette.
# Arguments :   - TODO.
# NB : `gmic` ne fonctionne pas s'il y a un guillemet double dans le nom d'un fichier
#    : Pour cela, la solution est de renommer temporairement le fichier source
parallel_img_to_vignette() {
    NOM_SOURCE="$1"
    NOM_DEST="$2"
    NOM_INDEX="$3"
    IS_FORCING="$4"
    img="$5"                         # Attention, paramètre délégué en dernier !

    # Prévention des images qui n'en sont pas
    if [ ! -f "$img" ] || [[ $(file -b "$img") != 'JPEG '* ]];
    then
        return 0
    fi

    NOM_VIGNETTE="${NOM_DEST}/vignette_$(basename "$img")"
    NOM_VIGNETTE="${NOM_VIGNETTE//\\/__bslash__}"
    NOM_VIGNETTE="${NOM_VIGNETTE//\"/__dquote__}"

    # Résolution des conflits liés aux guillemets doubles dans `identify` et `gmic`
    mv "$img" "${img//\"/__dquote__}"  2> /dev/null # `"` -> `__dquote__`
    img="${img//\"/__dquote__}"

    # Génération du code HTML et de la vignette
    if [ "$IS_FORCING" = true ];
    then
        img_to_vignette "$img" "$NOM_VIGNETTE"
        # au_moins_une_generation=true

        generate_img_fragment "$NOM_VIGNETTE" "$img" >> "$NOM_INDEX"
        echo "*** [Mode Force] La vignette $(basename "$NOM_VIGNETTE") a bien été générée."
    else
        if [ ! -f "$NOM_VIGNETTE" ];
        then
            img_to_vignette "$img" "$NOM_VIGNETTE"
            # au_moins_une_generation=true

            generate_img_fragment "$NOM_VIGNETTE" "$img" >> "$NOM_INDEX"
            echo "*** La vignette $(basename "$NOM_VIGNETTE") a bien été générée."
        else
            # TODO. Améliorer la sortie et créer une barre de chargement.
            echo ">> $img. Génération impossible, vignette existante."
        fi
    fi

    mv "${img//\"/__dquote__}" "${img//__dquote__/\"}" 2> /dev/null  # `__dquote__` -> `"`
}


# TODO. Associe la création d'une vignette à une commande gmic
# Arguments :   - Nom de l'image, nom de la vignette, [OPTIONS GMIC]
img_to_vignette() {
    gmic "$img" -cubism , -resize 300,300 -output "$NOM_VIGNETTE" 2> /dev/null
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
    html_head "$NOM_INDEX" > "$NOM_INDEX"
    html_title >> "$NOM_INDEX"

    # 2. Génération des vignettes et de leur légende
    generate_parallel_vignette "$NOM_SOURCE" "$NOM_DEST" \
        "$IS_FORCING" "$NOM_INDEX" "$PARALLELES"

    # 3. Ecrire le nouveau fichier : pied-de-page
    html_tail >> "$NOM_INDEX"

    echo ''
    echo "-- Fin de la génération --"
    echo "-- firefox ${NOM_INDEX} pour voir le résultat. --"
}


# TODO. Crée la page .HTML d'une seule image
# Arguments :
generate_html_page() {
    NOM_VIGNETTE="$(basename "$img_actuel")"
    NOM_VIGNETTE="${NOM_VIGNETTE%.*}.html"
    NOM_PAGE="${NOM_DEST}/pages/${NOM_VIGNETTE}"

    # Suppression de l'ancien fichier
    if [ -f "$NOM_PAGE" ];
    then
        rm "$NOM_PAGE"
    fi

    # 1. Ecrire le nouveau fichier : en-tête
    touch "$NOM_PAGE"
    html_head "Galerie | $(basename "${img_actuel}")" > "$NOM_PAGE"
    html_title "$(basename "${img_actuel}")" >> "$NOM_PAGE"

    # 2. Copier l'image source dans la destination pour la pleine page
    # NB : Si l'image source n'existe plus, on ne crée pas la pleine page
    fichier_prefixe="vignette_"
    fichier_nom=$(basename "$img_actuel")
    fichier_nom="${fichier_nom#$fichier_prefixe}"
    fichier_nom="${fichier_nom//__bslash__/\\}"
    fichier_nom="${fichier_nom//__dquote__/\"}"

    if [ -f "${NOM_SOURCE}/${fichier_nom}" ];
    then
        fichier_remplace="${fichier_nom//\\/__bslash__}"
        cp "${NOM_SOURCE}/${fichier_nom}" "${NOM_DEST}/sources/${fichier_remplace//\"/__dquote__}"
    else
        echo "oui mais non $fichier_nom"
        return
    fi

    # 3. Ajouter l'image et les boutons de navigation
    if [ "$img_precedent" != "" ];
    then
        fichier_precedent=$(basename "$img_precedent")
        fichier_precedent="${fichier_precedent%.*}.html"
        fichier_precedent="${fichier_precedent//\\/__bslash__}"
        fichier_precedent="${fichier_precedent//\"/__dquote__}"
    else
        fichier_precedent=""
    fi

    if [ "$img_suivant" != "" ];
    then
        fichier_suivant=$(basename "$img_suivant")
        fichier_suivant="${fichier_suivant%.*}.html"
        fichier_suivant="${fichier_suivant//\\/__bslash__}"
        fichier_suivant="${fichier_suivant//\"/__dquote__}"
    else
        fichier_suivant=""
    fi

    # Ajout des boutons, de l'image et du pied-de-page
    fichier_nom="${fichier_nom//\\/__bslash__}"
    fichier_nom="${fichier_nom//\"/__dquote__}"

    html_image_and_buttons "${NOM_SOURCE}" "${fichier_nom}" \
        "${fichier_precedent}" "${fichier_suivant}" "${NOM_INDEX}">> "$NOM_PAGE"
    html_tail >> "$NOM_PAGE"
}


# TODO. Fonction principale pour la génération des fichiers
# Arguments :   - TODO.
galerie_main() {
    NOM_INDEX="$1"
    NOM_SOURCE="$2"
    NOM_DEST="$3"

    IS_VERBOSE="$4"
    IS_FORCING="$5"
    PARALLELES="$6"

    # Génération du fichier HTML et des vignettes
    generate_html "$NOM_INDEX" "$NOM_DEST" "$IS_FORCING" "$PARALLELES"
}
