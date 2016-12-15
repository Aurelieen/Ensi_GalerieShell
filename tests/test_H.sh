#! /bin/sh

# Test H :
# SOURCE : "source_testH" existe déjà et n'est jamais supprimée.
# DESTINATION : "dest_H", créé par l'exécutable.

# Caractéristiques :
# - Ce dernier test utilise de vraies images.
# - La galerie ainsi générée peut afficher l'information de la date de prise de vue.

# ------------------------
# | Comportement attendu |
# ------------------------
# La galerie permet de consulter les dates de prise de vue des images.
# Pour y accéder, firefox dest_H/index.html
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr dest_H

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST H.
Ce dernier test utilise de vraies images.
La galerie ainsi générée peut afficher la date de prise de vue.

>> galerie-shell.sh --source "source_testH" --dest "dest_H"
${reset}
EOM

# Appel de l'exécutable GALERIE.
galerie-shell.sh --source "source_testH" --dest "dest_H"

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST H. Comportement attendu :
La galerie permet de consulter les dates de prise de vue des images.
Pour y accéder, firefox dest_H/index.html
${reset}
EOM
