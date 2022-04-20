REM ----------STAGE 1 : EXPORT BANDES----------
REM creation d'un repertoire de travail et export de chaque bande de l'otho

mkdir "path\prod"

gdal_translate -of GTiff -co COMPRESS=DEFLATE -a_srs EPSG:srs -co NUM_THREADS=ALL_CPUS -co SPARSE_OK=TRUE -co INTERLEAVE=PIXEL -co TILED=YES -a_nodata -9999 -b 1 "path\input_ortho.tif" "path\prod\b1.tif"
gdal_translate -of GTiff -co COMPRESS=DEFLATE -a_srs EPSG:srs -co NUM_THREADS=ALL_CPUS -co SPARSE_OK=TRUE -co INTERLEAVE=PIXEL -co TILED=YES -a_nodata -9999 -b 2 "path\input_ortho.tif" "path\prod\b2.tif"
gdal_translate -of GTiff -co COMPRESS=DEFLATE -a_srs EPSG:srs -co NUM_THREADS=ALL_CPUS -co SPARSE_OK=TRUE -co INTERLEAVE=PIXEL -co TILED=YES -a_nodata -9999 -b 3 "path\input_ortho.tif" "path\prod\b3.tif"
gdal_translate -of GTiff -co COMPRESS=DEFLATE -a_srs EPSG:srs -co NUM_THREADS=ALL_CPUS -co SPARSE_OK=TRUE -co INTERLEAVE=PIXEL -co TILED=YES -a_nodata -9999 -b 4 "path\input_ortho.tif" "path\prod\b4.tif"

REM ----------STAGE 2 : ASSEMBLAGE----------
REM assemblage des tuiles selon la résolution voulue

gdalbuildvrt -separate "path\prod\rgbza.vrt" -tr resX rexY "path\prod\b1.tif" "path\prod\b2.tif" "path\prod\b3.tif" "path\input_dem.tif" "path\prod\b4.tif"

REM ----------STAGE 3 : PRODUCTION FINALE----------
REM découpe du vrt selon l'emprise du projet et conversion du raster en GTiff

gdalwarp -cutline "input.gpkg" -csql "SELECT geom FROM nom_table WHERE champ='valeur'" -crop_to_cutline -of GTiff -co COMPRESS=DEFLATE -ot Float64 -s_srs EPSG:srs -co NUM_THREADS=ALL_CPUS -co SPARSE_OK=TRUE -co INTERLEAVE=PIXEL -co TILED=YES -dstnodata -9999 -overwrite "path\prod\rgbza.vrt" "path\rgbza.tif"

rmdir /s /q "path\prod"
