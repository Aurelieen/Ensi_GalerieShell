#! /bin/sh

# Test G :
# SOURCE : "source_testG/sou rce" existe déjà et n'est jamais supprimée.
# DESTINATION : "../dest G", créé par l'exécutable.

# Caractéristiques :
# - Ce test récapitule l'ensemble des tests précédents.
# - On vérifie que la galerie est capable :
# -- de chercher des sources et des destinations qui ne sont pas dans le même dossier ;
# -- de générer des vignettes forcées en parallèle, avec le mode verbeux et un index changé ;
# -- de fonctionner avec des chemins qui contiennent des espaces ;
# -- d'ignorer le contenu qui ne peut pas être transformé en vignette ;
# -- de transformer en vignettes des fichiers avec des caractères à problème ;
# - Le dossier "source_testG/sou rce" permet de vérifier tout cela.

# ------------------------
# | Comportement attendu |
# ------------------------
# La galerie est générée correctement avec l'ensemble des contraintes précédentes.
# Pour accéder à la galerie, taper firefox "../dest G/home.html"
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr "../dest G"

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST G.
Ce test récapitule l'ensemble des tests précédents.
On vérifie que la galerie est capable :
    - de chercher des sources et des destinations qui ne sont pas dans le même dossier ;
    - de générer des vignettes forcées en parallèle, avec le mode verbeux et un index changé ;
    - de fonctionner avec des chemins qui contiennent des espaces ;
    - d'ignorer le contenu qui ne peut pas être transformé en vignette ;
    - de transformer en vignettes des fichiers avec des caractères à problème ;
Le dossier "source_testG/sou rce" permet de vérifier tout cela.

>> galerie-shell.sh --source "source_testG/sou rce" --dest "../dest G" --parallel 8 --force --verb --index "home.html"
${reset}
EOM

# Appel de l'exécutable GALERIE.
galerie-shell.sh --source "source_testG/sou rce" --dest "../dest G" --parallel 8 --force --verb --index "home.html"

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST G. Comportement attendu :
La galerie est générée correctement avec toutes les contraintes précédentes.
Pour accéder à la galerie, taper firefox "../dest G/home.html"
${reset}
EOM
