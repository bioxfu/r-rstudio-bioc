docker kill rstudio
docker rm rstudio
docker run --name rstudio -d -p 5050:8787 bioxfu/r-rstudio-bioc 
