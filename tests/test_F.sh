#! /bin/sh

# Test F :
# SOURCE : "source_testF" existe déjà et n'est jamais supprimée, elle contient des fichiers à problème.
# DESTINATION : dest_F, créé par l'exécutable.

# Caractéristiques :
# - On vérifie que le script n'échoue pas sur les cas suivants :
# -- Fichiers avec des espaces à l'intérieur ;
# -- Fichiers avec un backslash à l'intérieur (gênant pour CSS) ;
# -- Fichiers avec une simple quote dedans ;
# -- Fichiers avec une double quote dedans ;
# -- Fichiers avec une astérisque dedans ;

# ------------------------
# | Comportement attendu |
# ------------------------
# Les caractères spéciaux ne font pas échouer le programme.
# Les vignettes avec espace, astérisque ou simple quote sont bien créées.
# Les vignettes avec backslash ou double-quote sont renommées avec des constantes pour respecter la RFC 3986 sur les URL.
# Pour afficher la galerie, firefox dest_F/index.html
# ------------------------

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

rm -fr "dest_F"

# INSTRUCTIONS. Principe du test.
cat <<- EOM
${blue}${bold}
TEST F.
Dans ce test, on vérifie que le script n'échoue pas sur les cas suivants :
    - Fichiers avec des espaces à l'intérieur ;
    - Fichiers avec un backslash à l'intérieur (gênant pour CSS) ;
    - Fichiers avec une simple quote (') dedans ;
    - Fichiers avec une double quote dedans ;
    - Fichiers avec une astérisque dedans ;
Le dossier "source_testF" contient des fichiers avec des caractères spéciaux.

>> galerie-shell.sh --source source_testF --dest dest_F
${reset}
EOM

# Appel de l'exécutable GALERIE.
galerie-shell.sh --source source_testF --dest dest_F

# INSTRUCTIONS. Comportement attendu.
cat <<- EOM
${blue}${bold}
RESULTAT DU TEST F. Comportement attendu :
Les caractères spéciaux ne font pas échouer le programme.
Les vignettes avec espace, astérisque ou simple quote sont bien créées.
Les vignettes avec backslash ou double-quote sont renommées avec des constantes pour respecter la RFC 3986 sur les URL.
Pour afficher la galerie, firefox dest_F/index.html
${reset}
EOM
