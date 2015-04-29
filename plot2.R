# ------------------------------------------------------------------------------
# Q U E S T I O N   2
# ------------------------------------------------------------------------------
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.

# ------------------------------------------------------------------------------
# B E G I N   D A T A S E T
# ------------------------------------------------------------------------------
# The datasets provided for this assignment are large and consume a lot of time
# for reading and loading. To eliminate this penalty, if the user is running the
# "plot" scripts in this project serially, we will check the environment for the
# presence of the data before we move on to reading it. NOTE: the files are
# assumed to reside in the working directory (uncompressed) and their names are
# unchanged from the project instructions. ALSO: we don't encapsulate repetitive
# code in "functions" because we want all input/output to occur in local scope.

if (file.exists("summarySCC_PM25.rds") & 
        file.exists("Source_Classification_Code.rds")) {
    #
    # Go to next step.
    #
} else {
    #
    # NOTE: Combining 'unzip' with 'readRDS' would allow us to read the archive
    # file into our data frame(s), e.g. df <- readRDS(unzip(arhive,filename)) 
    # and we would save the 'unzip' time to do this in two steps. However, we
    # lose some important flexibility in combining this step and the archived
    # source files would not be in our working directory (only the archive)!
    #
    archiveUrl <- 
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    archiveFile <- basename(archiveUrl)
    filePath <- file.path(getwd(), archiveFile)
    download.file(url = archiveUrl, destfile = filePath, method = "curl")
    if (file.exists(archiveFile)) {
        unzip(archiveFile)
    }
}

if (exists("NEI") && is.data.frame(get("NEI"))) {
    #
    # Go to next step.
    #
} else {
    if (file.exists("summarySCC_PM25.rds")) {
        #
        # Read the RDS file into a data frame.
        #
        message("Reading in data. This will take a few moments!")
        NEI <- readRDS("summarySCC_PM25.rds")
    } else {
        #
        # Notify the user we have a fatal error.
        #
        stop("The project datasource \"summarySCC_PM25.rds\" is 
        missing. You must download this file to your working 
        directory before you can continue.", call. = FALSE)
    }
}

if (exists("SCC") && is.data.frame(get("SCC"))) {
    #
    # Go to next step.
    #
} else {
    if (file.exists("Source_Classification_Code.rds")) {
        #
        # Read the RDS file into a data frame.
        #
        message("Reading in data. This will take a few moments!")
        SCC <- readRDS("Source_Classification_Code.rds")
    } else {
        #
        # Notify the user we have a fatal error.
        #
        stop("The project datasource \"Source_Classification_Code.rds\" is 
        missing. You must download this file to your working 
        directory before you can continue.", call. = FALSE)
    }
}

#-------------------------------------------------------------------------------
# E N D   D A T A S E T
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# B E G I N   P L O T
# ------------------------------------------------------------------------------
# The "dplyr" package has fast and efficient functions for processing our data
# that outperform the base "stats" package. We want to use "dplyr" so we will
# check for the package and determine if it is loaded into the namespace. If
# absent we will install it by default.

if ("dplyr" %in% installed.packages()) {
    if ("dplyr" %in% loadedNamespaces()) {
        #
        # Go to next step.
        #
    } else {
        library(dplyr, quietly = TRUE)
    }
} else {
    message("One moment... need to install \"dplyr\" package.")
    install.packages("dplyr", quiet = TRUE)
    library(dplyr, quietly = TRUE)
}

# Let's use the the device driver settings we used in "Project 1" of this
# course. Set the output device driver to PNG and give the parameters to define 
# the file name, default print size, background color, and type for windows.

png(file = "plot2.png",
    width = 480, 
    height = 480, 
    units = "px", 
    pointsize = 12,
    bg = "white",
    type = "cairo")

# We are using the "graphics" plotting system for this plot. A classic "barplot"
# with vertical bars would seem to be the best choice. There are sufficient
# parameters in this function to fully format and describe the plot, and we
# will not have to overlay additional information or features. NOTE: The
# emisions values are large. By default, boxplot will render very large numbers
# in scientific notation, and in this case each value is rendered to base 10 and
# exponent six (10^6 = millions). So, we scale the "emissions" number to get a 
# more reasonable rendering and note that in the plot title.

df <- NEI %>% 
    filter(fips == "24510") %>% 
        select(year,Emissions) %>%
            group_by(year) %>% 
                summarize(emissions = sum(Emissions))

barplot(
    df$emissions,
    names.arg = df$year,
    col = "cornflowerblue",
    font.main = 1,
    font.lab = 2,
    family = "sans",
    xlab = "Year",
    ylab = "PM2.5 Emissions ( In Tons )",
    main = "Total PM2.5 Emissions From All Baltimore City Sources")

# Turn this device driver (PNG) off (restore to console output).
#
dev.off()

# ------------------------------------------------------------------------------
# E N D   P L O T
# ------------------------------------------------------------------------------
