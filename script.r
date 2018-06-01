

if (Sys.getenv("RSTUDIO") == 1) { ### 1 -> development enviroment
  
  libraryRequireInstall = function(packageName, ...)
  {
    if(!require(packageName, character.only = TRUE))
      warning(paste("*** The package: '", packageName, "' was not installed ***", sep=""))
  }
  
  internalSaveWidget <- function(widget, fname)
  {
    widget
  }
  
} else {

    source('./r_files/flatten_HTML.r')
  
  }

############### Library Declarations ###############
libraryRequireInstall("DT")


#######################################################
# List packages in the service
# Author: Fabio Correa
# October 2017
#######################################################

lsp <- function(package, all.names = FALSE, pattern) 
{
  package <- deparse(substitute(package))
  ls(
    pos = paste("package", package, sep = ":"), 
    all.names = all.names, 
    pattern = pattern
  )
}

MyData <- data.frame(installed.packages())
MyData$LibPath <- NULL
MyData$License <- NULL
MyData$License_is_FOSS <- NULL
MyData$License_restricts_use <- NULL
MyData$OS_type <- NULL
MyData$MD5sum <- NULL
MyData$NeedsCompilation <- NULL

MyData <- MyData[order(MyData$Package),]
rownames(MyData) <- NULL

kt <- datatable(MyData,
                class = "compact hover stripe", # white-space: nowrap
                #filter = list(position = 'top'),
                caption = paste0("The Power BI Service is running ", R.version.string),
                width = "100%",
                height = "100%",
                options = list(dom = "<'top' flp>rti",
                               autoWidth = FALSE,
                               rownames = TRUE,
                               searching = TRUE,
                               pagingType = "simple_numbers",
                               pageLength = 15,
                               lengthMenu = c(5, 10, 15, 20, 25, 30),
                               scrollY = TRUE,
                               scrollX = TRUE,
                               initComplete = JS("
                                                function(settings, json) {
                                                    $(this.api().table().body()).css({
                                                      'font-size': '75%'
                                                     });
                                                    $(this.api().table().header()).css({
                                                     'background-color': '#000',
                                                     'color': '#fff',
                                                     'font-size': '80%'
                                                    });
                                                 }
                                              ")
                )
)


kt$sizingPolicy$browser$padding <- 0

#######################################################
# Generate output

internalSaveWidget(kt, "out.html")

