#! /bin/sh

# Test E :
# SOURCE : "source_testE" existe déjà et n'est pas supprimée, elle contient des fichiers à problème.
# DESTINATION : dest_E, créé par l'exécutable.

# Caractéristiques :
# - On vérifie que le script ne prend pas en compte les fichiers problématiques suivants :
# -- Répertoires
# -- Fichiers dont l'extension n'est pas `.jpg`
# -- Fichiers `.jpg` vides
# -- Fichiers `.jpg` qui n'en sont pas (illisibles)
# - Le dossier "source_testE" contient des fichiers avec ces problèmes et des fichiers normaux.

# ------------------------
# | Comportement attendu |
# ------------------------
# Tous les fichiers problématiques (cf. liste ci-dessus) ont été ignorés.
# Les fichiers lisibles font partie de la galerie.
# Pour lancer la galerie, utiliser firefox dest_E/index.html
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr "dest_E"

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST E.
Dans ce test, on vérifie que le script ne prend pas en compte les fichiers problématiques suivants :
    - Répertoires ;
    - Fichiers dont l'extension n'est pas '.jpg' ;
    - Fichiers '.jpg' vides ;
    - Fichiers '.jpg' qui sont illisibles ou mal formatés ;
Le dossier "source_testE" contient des fichiers avec ces problèmes et des fichiers normaux.

>> galerie-shell.sh --source source_testE --dest dest_E
${reset}
EOM

# Appel de l'exécutable GALERIE.
galerie-shell.sh --source source_testE --dest dest_E

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST E. Comportement attendu :
Tous les fichiers problématiques (cf. liste ci-dessus) ont été ignorés.
Les fichiers lisibles font partie de la galerie.

Il y a quatre fichiers lisibles générés et quatre fichiers/dossiers ignorés.
Pour lancer la galerie, utiliser firefox dest_E/index.html
${reset}
EOM
