REM création parking_ads

REM creation LISTE des tuiles raster
dir /b /s "path\*.tif" > "path\parkings.txt"

REM creation VRT des tuiles raster
gdalbuildvrt ^
-input_file_list "path\parkings.txt" ^
-a_srs EPSG:2154 ^
-addalpha ^
"path\parkings_vrt.vrt"

REM raster valeur unique 0
gdal_create -burn 0 -bands 1 -if "path\parkings_vrt.vrt" "path\val0.tif"

REM creation TIF des tuiles raster
gdal_translate ^
-of GTiff ^
-co COMPRESS=DEFLATE ^
-r BILINEAR ^
"path\parkings_vrt.vrt" "path\parkings_trous.tif"

REM LISTE merge.txt déjà créé
REM l.1 val0 - l.2 trous 

gdalbuildvrt ^
-input_file_list "path\merge.txt" ^
-a_srs EPSG:2154 ^
-overwrite ^
-addalpha ^
"path\parkings_vrt.vrt"

REM crop valeur unique !!parkings.shp à reproj en 2154!!
gdalwarp ^
-of COG ^
-co COMPRESS=DEFLATE ^
-co BIGTIFF=YES ^
-co NUM_THREADS=ALL_CPUS ^
-co RESAMPLING=BILINEAR ^
-co OVERVIEWS=AUTO ^
-co PREDICTOR=3 ^
-co MAX_Z_ERROR=0.01 ^
-cutline "path\parkings_cor_l93.shp" ^
-crop_to_cutline ^
-dstnodata -9999 ^
-overwrite ^
"path\parkings_vrt.vrt" "path\parking_ads.tif"

REM suppression de la bande 2 et nodata à -9999
gdal_translate ^
-of COG ^
-co COMPRESS=DEFLATE ^
-co BIGTIFF=YES ^
-co NUM_THREADS=ALL_CPUS ^
-co RESAMPLING=BILINEAR ^
-co OVERVIEWS=AUTO ^
-co PREDICTOR=3 ^
-co MAX_Z_ERROR=0.01 ^
-b 1 ^
-a_nodata -9999 ^
"path\parking_ads_a_compresser.tif" "path\parking_ads.tif"

