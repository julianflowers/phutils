#' Programmatically edit text files.
#'
#' A tool a bit like unix/linux sed that can go through a directory and
#' optionally its sub-directories changing values. It can optionally
#' keep backups with the date added to the file name and is also
#' able to run without changing anything to show which files will be changed and
#' how they will be changed so you can see if it does what you want. This is the default mode (i.e. paranoid).
#' 
#' @details There is a "magic" variable @@FILE@@ that you can use in your replacement (new)
#' expression. This will be replaced by the name of the file that is being changed.
#'
#' @param old The expression that you want to change
#' @param new The replacement expression.
#' @param path The path to search for files
#' @param pattern The file pattern
#' @param recursive Search for files recursively?
#' @param ignore.case When searching for file should the case be ignored?
#' @param show.only If TRUE (the default) don't actually change anything. Only really useful if verbose = TRUE
#' @param verbose If TRUE (the default) provide verbose information about the changes.
#' @param make.backup If TRUE (the default) then make a back-up of the files that are changed.
#' @param ... Other options to pass to gsub()
#' @author David Whiting, david.whiting@@publichealth.me.uk
#'
#' @seealso 
#' \code{\link{file.grep}}
#' @export
#' @return Invisibly returns a dataframe showing the files matched, and the lines that match before and after changes.
#'
rsed <- function(old = NULL, new = NULL,
                 path = ".", pattern = NULL, recursive = FALSE,
                 ignore.case = FALSE, show.only = TRUE, verbose = TRUE,
                 make.backup = TRUE, ...) {
  
  if (is.null(old)) stop("Please specify an expression to replace (old = NULL)")
  if (is.null(new)) stop("Please specify a replacement expression (new = NULL)")
  
  x <- list.files(path = path, pattern = pattern, recursive = recursive,
                  ignore.case = ignore.case)
  modify.file <- function(infile, old, new, ...) {
    ret <- NULL
    xx <- readLines(infile)
    need.changing <- grep(old, xx)
    if (length(need.changing) > 0) {
      orig <- xx[need.changing]
      for (i in 1:length(need.changing)){
        line.to.change <- need.changing[i]
        if (!show.only & make.backup) file.copy(infile, paste0(infile, gsub(":", "-", Sys.time())))
        if (verbose) print(paste0("Line: ", line.to.change))
        print(paste0("(before): ", xx[line.to.change]))
        xx[line.to.change] <- gsub(old, new, xx[line.to.change], ...)
        ## Use a 'magic' variable to add the file name if used
        xx[line.to.change] <- gsub("@@FILE@@", infile, xx[line.to.change])
        if (verbose) 
          print(paste0("(after): ", xx[line.to.change]))
      }
      ret <- data.frame(file = infile, line = need.changing, before = orig, after = xx[need.changing])
      if (!show.only) writeLines(xx, con = infile)
    }
    ret
  }
  
  ret <- list()   
  for (i in 1:length(x)){
    if (verbose) print(x[i])
    ret[[i]] <- modify.file(x[i], old, new)
  }
  invisible(do.call("rbind", ret))
}
