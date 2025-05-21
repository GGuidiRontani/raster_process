REM ----------STAGE 1 : LISTES TUILES----------
REM creation d'un repertoire de travail et d'une liste des tuiles
mkdir path\prod
mkdir path\prod\listes
dir /b /s "path\tuiles\*.ext" > "path\prod\listes\tiles_list.txt"

REM ----------STAGE 2 : PROD VRT----------
REM assemblage des tuiles et ajout d'une bande alpha
gdalbuildvrt -input_file_list "path\prod\listes\tiles_list.txt" -addalpha -a_srs EPSG:XXXX -overwrite "path\prod\base.vrt"

REM ----------STAGE 3 : PROD ZIPVA----------
REM decoupe et sous-echantillonnage du vrt selon les emprises zipva
REM la compression deflate permet de na pas avoir les artefacts crees avec une compression jpeg
gdalwarp -cutline "path\zipva_multi_millesimes.gpkg" -csql "SELECT * FROM emprises_mel" -crop_to_cutline -of GTiff -co COMPRESS=DEFLATE -dstalpha -co BIGTIFF=IF_SAFER -co NUM_THREADS=ALL_CPUS -tr 5 5 -overwrite "path\prod\base.vrt"  "path\prod\zipva.tif"

REM ----------STAGE 4 : PROD VRT SOUS-PRODUITS----------
REM assemblage du vrt des tuiles et du tif sous-echantillonne
dir /b /s "path\prod\*" > "path\prod\listes\list_prod.txt"
gdalbuildvrt -input_file_list "path\prod\listes\list_prod.txt" -tr resX resY -a_srs EPSG:XXXX -overwrite "path\prod\temp_prod.vrt"

REM ----------STAGE 5 : PROD COG----------
REM conversion du vrt en COG
gdal_translate -of COG -co COMPRESS=JPEG -co BIGTIFF=IF_SAFER -co NUM_THREADS=ALL_CPUS -co RESAMPLING=LANCZOS -co OVERVIEWS=AUTO "path\prod\temp_prod.vrt" "path\aaaa_ortho_Xcm_pix_srs.tif"

REM ----------STAGE 6 : SUPPR TEMP----------
REM suppression des fichiers temp
rmdir /s /q path\prod
