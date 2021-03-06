% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rangemap_bound.R
\name{rangemap_bound}
\alias{rangemap_bound}
\title{Species distributional ranges based on administrative areas}
\usage{
rangemap_bound(occurrences, adm_areas, country_code, boundary_level = 0,
  polygons, kept_data = FALSE, dissolve = FALSE, save_shp = FALSE,
  name = "range_boundaries")
}
\arguments{
\item{occurrences}{(optional) a data.frame containing geographic coordinates of species
occurrences, columns must be: Species, Longitude, and Latitude. Geographic coordinates
must be in decimal degrees. If not defined, \code{adm_areas} must be defined and these
areas will be used as part of the species range.}

\item{adm_areas}{(optional, character) a vector of names of administrative areas known to
be occupied by the species, names depend on the \code{boundary_level} selected. Check the
\code{\link{adm_area_names}} documentation for an idea of how to define names in this parameter.
If not defined, \code{occurrences} must exist.}

\item{country_code}{(character) vector of country codes that will be considered when creating
the species range. Including neighbor countries may be necessary for obtaining better results.
Use \code{\link{rangemap_explore}} for a preview of all potential countries involved in the
analysis. Codes follow the ISO-3166-1 norm as in function \code{\link[raster]{getData}}. If not
defined, \code{polygons} must be included. Ignored if \code{polygons} is provided.}

\item{boundary_level}{(numeric) level of the administrative boundaries (from 0 to 5; 0 is the
country level and higher values indicate finer divisions). Default = 0. Ignored if \code{polygons}
is defined.}

\item{polygons}{(optional) a SpatialPolygonDataFrame object that will be used instead of boundaries
especified in \code{country_code} to create species ranges based on overlapping of species records
with these layer, as well as names defined in \code{adm_areas}. Projection must be Geographic
(longitude, latitude). If \code{adm_areas} is defined, \code{polygons} must have, as part of its data,
a fied (column) named "adm_areas" for selecting extra areas based on names. If defined, arguments
\code{country_code} and \code{boundary_level} will be ignored.}

\item{kept_data}{(logical) if TRUE and \code{polygons} is not defined, data dowloaded from the GADM
data base will be kept in the working directory. Useful if all or part of the downloaded files will
be used in posterior analyses since those files will not be downloaded again and time will be saved.
Default = FALSE.}

\item{dissolve}{(logical) if TRUE, distint polygons selected as part of the species range will
be disolved for creating simpler shapes, default = FALSE. Owing to the high resolution in the GADM
data the dissolving process may be quite time consuming, specially if the species has a broad
distribution.}

\item{save_shp}{(logical) if TRUE, shapefiles of the species range, occurrences, extent of occurrence
and area of occupancy will be written in the working directory. Default = FALSE.}

\item{name}{(character) valid if \code{save_shp} = TRUE. The name of the shapefile to be exported.
A suffix will be added to \code{name} depending on the object as follows: species extent of
occurrence = "_extent_occ", area of occupancy = "_area_occ", and occurrences = "_unique_records".
Default = "range_boundaries".}
}
\value{
A named list containing: (1) a data.frame with information about the species range, and
SpatialPolygon objects of (2) unique occurrences, (3) species range, (4) extent of occurrence, and
(5) area of occurpancy. All Spatial objects will be in Azimuthal equal area projection. If only
\code{adm_areas}, the result will be a list of two elements: (1) a data.frame with information about
the species range, and (2) a SpatialPolygon object of the species range.
}
\description{
rangemap_bound generates a distributional range for a given species by
considering all the polygons of administrative entities in which the species has been
detected. An approach to the species extent of occurrence (using convex hulls) and the
area of occupancy according to the IUCN criteria are also generated. Shapefiles can be
 saved in the working directory if it is needed.
}
\details{
Data for countries defined in \code{country_code} are downloaded and loaded using the
\code{\link[raster]{getData}} funcion.
Iformation on country codes and names of administrative areas at distinct levels can be cosulted
using the data of this package: \code{\link{country_codes}} and \code{\link{adm_area_names}}.
}
\examples{
if(!require(rgbif)){
install.packages("rgbif")
library(rgbif)
}

# getting the data from GBIF
species <- name_lookup(query = "Dasypus kappleri",
                       rank="species", return = "data") # information about the species

occ_count(taxonKey = species$key[14], georeferenced = TRUE) # testing if keys return records

key <- species$key[14] # using species key that return information

occ <- occ_search(taxonKey = key, return = "data") # using the taxon key

# keeping only georeferenced records
occ_g <- occ[!is.na(occ$decimalLatitude) & !is.na(occ$decimalLongitude),
            c("name", "decimalLongitude", "decimalLatitude")]

# checking which countries may be involved in the analysis
rangemap_explore(occurrences = occ_g)

level <- 0
adm <- "Ecuador" # Athough no record is on this country, we know it is in Ecuador
dissolve <- FALSE
save <- TRUE
name <- "test"
countries <- c("PER", "BRA", "COL", "VEN", "ECU", "GUF", "GUY", "SUR", "BOL")

bound_range <- rangemap_bound(occurrences = occ_g, adm_areas = adm, country_code = countries,
                              boundary_level = level, dissolve = dissolve, save_shp = save,
                              name = name)

# see the species range in a figure
extent <- TRUE
occ <- TRUE
legend <- TRUE
north <- TRUE

# creating the species range figure
rangemap_fig(bound_range, add_extent = extent, add_occurrences = occ,
             legend = legend, northarrow = north)
}
