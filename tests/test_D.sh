#! /bin/sh

# Test D :
# SOURCE : "source espace", créée par le test.
# DESTINATION : "dest D/dest espace", créé par le test.

# Caractéristiques :
# - On teste les sources et les destinations qui comportent des espaces.
# - Cette fois, c'est le script de test qui crée la source et la destination, la galerie écrit dedans.

# ------------------------
# | Comportement attendu |
# ------------------------
# Les espaces ne posent aucun problème.
# La galerie ne crée ou n'écrase pas le dossier de destination mais écrit dedans.
# Pour ouvrir l'index, il faut lancer firefox "dest D/dest espace/index.html".
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr "source espace"
rm -fr "dest D/dest espace"

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST D.
Dans ce test, on vérifie que les espaces dans les chemins sont sans problème.
Cette fois, le script de test crée la source et la destination, et la galerie écrit dedans.

>> galerie-shell.sh --source "source espace" --dest "dest D/dest espace"
${reset}
EOM

# Création des images
mkdir -p "source espace"
mkdir -p "dest D/dest espace"
for i in `seq 1 16`;
do
    make-img.sh "source espace"/img_testd_"${i}".jpg
done

# Appel de l'exécutable GALERIE.
galerie-shell.sh --source "source espace" --dest "dest D/dest espace"

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST D. Comportement attendu :
Les espaces ne posent aucun problème.
La galerie ne crée ou n'écrase pas le dossier de destination mais écrit dedans.
Pour ouvrir l'index, il faut lancer firefox "dest D/dest espace/index.html".
${reset}
EOM
