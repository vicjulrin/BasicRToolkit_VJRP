# Set session parameters ####
## Load libraries to run the script ####
### Check and Install necessary libraries ####

packagesPrev<- installed.packages()[,"Package"] # Check and get a list of installed packages in this machine and R version

# packagesNeed Define the list of required packages from CRAN to run the script; empty c("") if no CRAN packages are used
packagesNeed<- c("magrittr", "devtools", "this.path", "dplyr"); packagesNeed<- packagesNeed[!packagesNeed==""] 
new.packages <- packagesNeed[!(packagesNeed %in% packagesPrev)]; if(length(new.packages)) {install.packages(new.packages, binary=T, force=T, dependencies = F, repos= "https://packagemanager.posit.co/cran/__linux__/jammy/latest")} # Check and install required packages that are not previously installed

# packagesRemotes Define the list of required external libraries to run the script; empty if no external libraries are used
packagesRemotes<- c(""); packagesRemotes<- packagesRemotes[!packagesRemotes==""] 
new.packagesRemotes <- packagesRemotes[!(packagesRemotes %in% packagesPrev)]; if(length(packagesRemotes)) {lapply(packagesRemotes, function(x) devtools::install_github(x))} # Check and install required packages that are not previously installed

### Load libraries ####
# Explicitly list the required packages throughout the entire script. Explicitly listing the required packages throughout the routine ensures that only the necessary packages are listed. Unlike 'packagesNeed', this list includes packages with functions that cannot be directly called using the '::' syntax. By using '::', specific functions or objects from a package can be accessed directly without loading the entire package. Loading an entire package involves loading all the functions and objects 
packagesList<-list("magrittr", "dplyr") 
lapply(packagesList, library, character.only = TRUE)  # Load libraries - packages  

# Set up the working environment ####

## Set output folder #### 
# Path to the folder where the exported results will be stored throughout the script; if it doesn't exist, it will be created
output_folder<- ""; dir.create(output_folder, recursive = T) 

## Set inputs ####
# Specify inputs and arguments required for the script (e.g., a <- 1)

#  Script body ####

## Load data ####
### Create example dataframe ####
df <- data.frame(col1 = 1:3, col2 = 4:6)

### Create object that stores the column name ####
new_col_name <- "col3"

### Use dplyr with objects that store column names ####
# We use !! and sym() to reference columns through objects with their names
# The := operator is used to assign a value to a column named from an object
df <- df %>% dplyr::mutate(!!sym(new_col_name) := col1 + col2)
