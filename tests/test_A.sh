#! /bin/sh

# Test A :
# SOURCE : Non mentionnée, répertoire actuel par défaut
# DESTINATION : Non mentionné, répertoire /dest par défaut

# Caractéristiques :
#   - La commande est appelée avec un minimum d'arguments

# ------------------------
# | Comportement attendu |
# ------------------------
# Le dossier /tests ne contient pas d'images.
# L'exécutable renvoie donc un message d'erreur et ne génère pas la galerie.
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr source dest

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST A.
La commande est appelée sans arguments.
On teste son comportement par défaut.

>> galerie-shell.sh
${reset}
EOM

# Appel de l'exécutable GALERIE.
galerie-shell.sh

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST A. Comportement attendu :
La galerie a cherché des images dans la source "." par défaut.
Il n'y a pas d'images dans ce répertoire donc aucune vignette ne se crée.
${reset}
EOM
