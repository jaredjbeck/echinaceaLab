#' create a data frame of scan filenames and batch ids.
#' 
#' This function takes all the scanned image files in a selected folder and
#' returns a dataframe with all file names, their associated batches and letnos.
#' 
#' @param path character directory or path containing the files of interest
#' @return dataframe that report characteristics of each file in the directory
#'   of interest
#'   
#' @keywords scan file batch letno
#' @examples
#'
#'\dontrun{
#'scans <- loadScans("I:\\Departments\\Research\\EchinaceaCG2012\\scanExamples")}
#'
#' @seealso \code{\link{check.batch}}
#'   
loadScans <- function(path = "."){
    x <- list.files(path, full.names = FALSE, 
                    recursive = TRUE, include.dirs = FALSE)
    filename <- basename(x)
    paths <- dirname(x) 
  scans <- data.frame(batch = paths, filename = filename)
  x <- as.character(scans$filename)
 #remove scan prefix and .jpg--this should work for 3 or 4-digit batch numbers
  nolets <- substr(x, nchar(x) - (nchar(x) - 2), nchar(x) - 4)
  lets <- substr(nolets, nchar(nolets) - 1, nchar(nolets)) 
  nos <- substr(nolets, 1, nchar(nolets) - 2)
  scans$letno <- paste(toupper(lets), nos, sep = "-")
  scans <<- scans
  scans
}


#' Compare letnos or nolets from scan files with harvest list.
#' 
#' This function compares the vector scans$letno with the vector hh.2012$letno. 
#' Make sure you set the working dircory to the directory that contains the 
#' dataframes scans and hh.2012.
#' 
#' @param batch character the hh.2013 dataframe has the batch field populated with experiment name. In 2012 and before batch was an integer identifier for a garden in cg1. batch defaults to SPP.
#' @param scansdf dataframe in format of output from function loadScans. The
#'   default name is scans.
#' @param harvestFile dataframe such as hh.2012 or hh.2013
#'  
#' @return names list of of interest
#'   
#' @keywords scan file batch letno
#' @examples
#'
#'\dontrun{
#'scans <- loadScans("I:\\Departments\\Research\\EchinaceaCG2012\\scanExamples")
#'check.batch("321")}
#'
#' @seealso \code{\link{loadScans}}
#'   
check.batch <- function(batch = "SPP", scansdf = scans, harvestFile = hh.2013){
  w <- setdiff(scansdf[scansdf$batch %in% batch, "letno"],
               harvestFile[harvestFile$batch %in% batch, "letno"])
  m <- setdiff(harvestFile[harvestFile$batch %in% batch, "letno"],
               scansdf[scansdf$batch %in% batch, "letno"])
  b  <- length(harvestFile[harvestFile$batch %in% batch, "letno"])
  s  <- length(scansdf[scansdf$batch %in% batch, "letno"])
  list(batchCount = b, scanCount = s, missingCount = length(m), 
       missing = m, wrong = w)
}
