#! /bin/sh

# Récupération du chemin absolu vers le répertoire contenant le
# script. $0 est le chemin (possiblement relatif) vers le script
# courant, "$(dirname "$0")" est le répertoire le contenant, et la
# combinaison de cd et pwd permet de récupérer un chemin absolu.
DIR=$(cd "$(dirname "$0")" && pwd)

# On demande au shell de lire le contenu de sub-script.sh Il n'y a pas
# de création de nouveau processus. Les définitions de fonctions de
# sub-script.sh seront visibles après cette ligne.
# La ligne de commentaire suivante sert uniquement à shellcheck (SC1090)
# shellcheck source=./utilities.sh
. "$DIR"/utilities.sh

(
html_head "Test de la génération de HTML"
html_title 'Ceci est un gros titre'
html_tail
) > index.html

echo "index.html generated. You can now run"
echo
echo "  firefox index.html"
echo
echo "to see the result."
