#! /bin/sh

# Test très simple qui teste galerie-shell avec :
# Répertoire source :
#  - chemin relatif
#  - pas de caractères spéciaux dans les noms de fichiers/répertoires
#  - contient des images, et uniquement des images.
# Répertoire destination :
#  - existant avant le lancement du script, vide.
#  - chemin relatif
#  - pas de caractères spéciaux dans les noms de fichiers/répertoires

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

galerie-shell.sh --source source --dest dest

if [ -f dest/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi
