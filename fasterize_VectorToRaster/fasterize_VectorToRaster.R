# Set session parameters ####
## Load libraries to run the script ####
### Check and Install necessary libraries ####

packagesPrev<- installed.packages()[,"Package"] # Check and get a list of installed packages in this machine and R version

# packagesNeed Define the list of required packages from CRAN to run the script; empty c("") if no CRAN packages are used
packagesNeed<- c("magrittr", "devtools", "this.path", "terra", "raster",  "sf", "fasterize"); packagesNeed<- packagesNeed[!packagesNeed==""] 
new.packages <- packagesNeed[!(packagesNeed %in% packagesPrev)]; if(length(new.packages)) {install.packages(new.packages, binary=T, force=T, dependencies = F, repos= "https://packagemanager.posit.co/cran/__linux__/jammy/latest")} # Check and install required packages that are not previously installed

# packagesRemotes Define the list of required external libraries to run the script; empty if no external libraries are used
packagesRemotes<- c(""); packagesRemotes<- packagesRemotes[!packagesRemotes==""] 
new.packagesRemotes <- packagesRemotes[!(packagesRemotes %in% packagesPrev)]; if(length(packagesRemotes)) {lapply(packagesRemotes, function(x) devtools::install_github(x))} # Check and install required packages that are not previously installed

### Load libraries ####
# Explicitly list the required packages throughout the entire script. Explicitly listing the required packages throughout the routine ensures that only the necessary packages are listed. Unlike 'packagesNeed', this list includes packages with functions that cannot be directly called using the '::' syntax. By using '::', specific functions or objects from a package can be accessed directly without loading the entire package. Loading an entire package involves loading all the functions and objects 
packagesList<-list("magrittr", "terra", "raster", "sf") 
lapply(packagesList, library, character.only = TRUE)  # Load libraries - packages  

# Set up the working environment ####
dir_work<- this.path::this.path() %>% dirname() # Assigns the script file's directory as the working environment

## Set output folder #### 
# Path to the folder where the exported results will be stored throughout the script; if it doesn't exist, it will be created
output_folder<- file.path(dir_work, "output"); dir.create(output_folder, recursive = T) 

## Set inputs ####
# Specify inputs and arguments required for the script (e.g., a <- 1)
path_Vector<- file.path(dir_work, "input/Arauca.gpkg") # Path to the vector file (GPKG, shapefile, GeoJSON, etc.) supported by the sf library

crs_coord<- 3395 # # EPSG code for the projected coordinate system (must be planar for adjust gridRes_meters in meters). More info: https://epsg.org/home.html
gridRes_meters<- 100 # Numerical value. Spatial resolution (pixel size) in meters for the grid
field_id<- NULL # Column name in `path_Vector` for raster values, set NULL to fill with 1s
path_export_rasterResult<- file.path(output_folder, "rasterResult") # Path of the filename for exporting the resulting raster


#  Script body ####

## Load data ####
vector_file <- sf::st_read(path_Vector) %>% sf::st_transform(crs_coord)

## Create raster base ####
raster_base <- terra::rast(extent= terra::ext(vector_file), crs= terra::crs(vector_file), resolution=gridRes_meters) %>% raster::raster()

## Rasterize polygon #### 
rasterResult<- fasterize::fasterize(vector_file, raster_base, field = field_id) %>% terra::rast()
plot(rasterResult)

## Export results ####
terra::writeRaster(rasterResult, paste0(path_export_rasterResult, ".tif") )
