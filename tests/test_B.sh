#! /bin/sh

# Test B :
# SOURCE : /source_B, créée dans le test.
# DESTINATION : /dest_B, créée par le script.

# Caractéristiques :
#   - (INDEX) On change le nom de l'index pour "home_b.html".
#   - (PARALLEL) Pour une galerie de 21 images, on en parallélise 7 à la fois.
#   - (VERBOSE) On active le mode verbeux.

# ------------------------
# | Comportement attendu |
# ------------------------
# Un dossier /dest_B avec 21 vignettes (et leurs pleines pages) est créé.
# Elles sont générées 7 par 7 grâce au paramètre --parallel
# Pour appeler l'index, il faut faire firefox dest_B/home_b.html
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr source_B
rm -fr dest_B

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST B.
La commande est appelée sur le dossier /source_B, créé dans le test.
Les vignettes sont placées dans un répertoire /dest_B, créé par le script.
     - On change le nom de l'index pour "home_b.html"
     - On génère 7 images à la fois grâce au parallélisme
     - On active le mode verbeux pour plus d'infomations.

>> galerie-shell.sh --source /source_B --dest dest_B --index "home_b.html" --parallel 7 --verb
${reset}
EOM

# Création des images
mkdir -p source_B
for i in `seq 1 21`;
do
    make-img.sh source_B/image"${i}".jpg
done

# Appel de l'exécutable GALERIE.
galerie-shell.sh --source /source_B --dest dest_B --index "home_b.html" --parallel 7 --verb

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST B. Comportement attendu :
Un dossier /dest_B avec 21 vignettes (et leurs pleines pages) est créé.
Elles sont générées en trois fois, 7 par 7 grâce au paramètre --parallel
Pour appeler l'index, il faut faire firefox dest_B/home_b.html
${reset}
EOM
