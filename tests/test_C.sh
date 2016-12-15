#! /bin/sh

# Test C :
# SOURCE : source_C1/source_C2, créée par le test.
# DESTINATION : dest_C1/dest_C2/dest_C3 créée par le script.

# Caractéristiques :
# - Dans ce test, on vérifie la cohérence entre les chemins absolus et relatifs.
# - La source est dans un sous-dossier de ce dossier de ce test.
# - La destination est dans un sous-sous-dossier de ce dossier.

# ------------------------
# | Comportement attendu |
# ------------------------
# L'accès via des chemins relatifs est résolu correctement.
# Pour appeler l'index, il faut faire firefox source_C1/source_C2/home.html
# NB : Cela fonctionne aussi si la source ou la destination sont dans des dossiers parents (../).
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr source_C1/source_C2
# rm -fr dest_C1/dest_C2/dest_C3

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST C.
Dans ce test, on vérifie la cohérence entre les chemins absolus et relatifs.
La source est dans un sous-dossier de ce dossier de ce test.
La destination est dans un sous-sous-dossier de ce dossier.
    - On change le nom de l'index pour "home.html" ;
    - On force la création d'une vignette si elle existe déjà ;

>> galerie-shell.sh --source source_C1/source_C2 --dest /dest_C1/dest_C2/dest_C3 --index "home.html" --force
${reset}
EOM

# Création des images
mkdir -p source_C1/source_C2
for i in `seq 1 8`;
do
    make-img.sh source_C1/source_C2/image"${i}".jpg
done

# Appel de l'exécutable GALERIE.
galerie-shell.sh --source /source_C1/source_C2 --dest /dest_C1/dest_C2/dest_C3 --index "home.html" --force

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST C. Comportement attendu :
L'accès via des chemins relatifs est résolu correctement.
Pour appeler l'index, il faut faire firefox source_C1/source_C2/home.html

On ne supprime pas le dossier entre chaque test. Si on réécute test_C, la création des vignettes est forcée.
On peut le vérifier en voyant que la couleur aléatoire des vignettes change à chaque exécution du test.
NB : Cela fonctionne aussi si la source ou la destination sont dans des dossiers parents (../).
${reset}
EOM
