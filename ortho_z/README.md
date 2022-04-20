# Objectif
Ajouter des valeurs altimétriques à une orthophotograhie

# Présentation générale
L'utilisation de ce type de produit implique une application permettant la lecture de toutes les bandes d'un raster. Idéalment un outils SIG. En plus des valeurs RGB de l'orthophotograhie, l'utilisateur pourra intérroger ou afficher les valeurs altimétriques du raster.
### Outils
Agisoft Metashape et GDAL
### Données
Une orthophotograhie et un modèle numérique dont les résolutions sont identiques, ou du moins très proches.

# Méthodologie
#### Choix methodologiques
Le produit final attendu comportera 5 bandes :
-	Bande 1, rouge,
-	Bande 2, vert,
-	Bande 3, bleu,
-	Bande 4, altimétrie et,
-	Bande 5, masque

Les valeur RVB sont à l'origine des entiers et celles altimétriques, des flottantes. Pour conserver un niveau de précision suffisant sur les valeurs altimétriques, toutes les valeurs du produit final doivent être converties en flottantes. Cela implique un rendu légèrement différent sur les bandes RVB.

Le produit fini est un GTiff car l'étendue des productions ne nécessite pas la production de COG. La chaine reste adaptable pour la production de GTiff avec le profil COG.

#### Chaine opératoire
La chaine se décompose en trois grandes phases :
-	l'enregistrement de chaque bande de l'orthophotograhie dans un raster propre,
-	l'assemblage des bandes de l'orthophotograhie et du modèle numérique dans un vrt, puis,
-	la production du résultat découpé selon une emprise voulue.
Notez que la phase de découpe peut être remplacée par une simple convertion en utlisant l'outils gdal_translate et en modifiant l'appel des options *-dstnodata* et *-s_srs* par *-a_nodata* et *-a_srs*.
Pour que les différentes bandes soient compatibles, il convient de spécifier la résolution du produit attendu lors de la phase d'assemblage avec l'option *-tr resX rexY*.

Pour être exécutable, il convient de modifier le fichier gdal_ortho_z.bat comme il suit :
-	Replacer toutes les occurrences de path par le nom du répertoire de travail.
-	Définir le système de projection selon son code EPSG dans l'appel d'option *-a_srs EPSG:* (l. 6 à 9 et 19).
-	Définir la résolution du produit fini avec l'option *-tr resX rexY* (l. 14).
