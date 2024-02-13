## RESET
rm(list= ls())
graphics.off()
cat('\014')


# ############################################################################ #
#
## DESCRIPCIÓ:    Script per descarregar mensualment les dades de cobatest Tool. 
#
## VERSIO:  13-02-2024
#
# ############################################################################ #



library(data.table)
library(odbc)
library(DBI)
library(openxlsx)
#sort(unique(odbcListDrivers()[[1]]))

TODAY <- format(Sys.Date(), '%Y%m%d') 


YEAR <- '2024'
MONTH <- '01'

# -------------------------------------------------------------------------- #
# SET CONNECTION                                                          ####
# -------------------------------------------------------------------------- #

# Conexió al servidor ICO
driver    <- "SQL Server"
server    <- "icosrvceeiscat01.ico.scs.local"  
database  <- "COBATEST"        
uid       <- "jaceiton"      ## User ID
# cobatest    "GvqmXGhQqC*+"

con <- dbConnect(odbc(),
                 Driver = driver,
                 Server = server, 
                 Database = database,
                 UID = uid,
                 PWD = rstudioapi::askForPassword("Database Password"))

# help(DBI)
# dbGetInfo(con)
# dbGetQuery(con, "SELECT * FROM table;")                                     # QUERY table
# odbcListObjects(con)                                                        # Top level objects
# odbcListObjectTypes(con)                                                    # Database structure
# odbcListDataSources()                                                       # All data sources
# odbcListDrivers()                                                           # All drivers
# odbcListObjects(con, catalog=database, schema="dbo")                        # Tables in a schema
# odbcListColumns(con, catalog=database, schema="dbo", table= cobatest )      # List columns in a table


# _______________________________________________________________________ ####
# -------------------------------------------------------------------------- #
# READ TABLES                                                             ####
# -------------------------------------------------------------------------- #

## cobatest_export   ####
# --------------------- #
cobatest_export <- "export_cobatest"
cobatest_export <- dbReadTable(con, cobatest_export)
cobatest_export <- setDT(cobatest_export)
# fwrite(cobatest_export, paste0("out/cobatest_export", TODAY, ".csv"))
# write.xlsx(cobatest_export, paste0("out/cobatest_export", TODAY,".xlsx"))


## hg_centros        ####
# --------------------- #
hg_centro <- "hg_centro"
hg_centro <- dbReadTable(con, hg_centro)
hg_centro <- setDT(hg_centro)


# ## ext_log_entries        ####
# # -------------------------- #
# ext_log_entries <- "ext_log_entries"
# ext_log_entries <- dbReadTable(con, ext_log_entries)
# ext_log_entries <- setDT(ext_log_entries)


# _______________________________________________________________________ ####
# -------------------------------------------------------------------------- #
# PROC TABLES                                                             ####
# -------------------------------------------------------------------------- #

## Subset MES-ANY       ####
# ------------------------ #
cat(paste(colnames(cobatest_export), collapse = '\n'))

# Seleccionem dades del MES-ANY que volem exportar. 
cobatest_export[, c("visit_day", "visit_month", "visit_year") := tstrsplit(x = date_of_visit, split= '/')]
cobatest_export[, .N, visit_year][order(visit_year)]
cobatest_export[, .N, visit_month][order(visit_month)]

coba <- unique(cobatest_export[visit_year == YEAR & visit_month == MONTH])



# _______________________________________________________________________ ####
# -------------------------------------------------------------------------- #
# SAVE                                                                    ####
# -------------------------------------------------------------------------- #

# saveRDS(coba, paste0("data/cobatest_export/cobaexport_", MONTH, "_", YEAR, "_", TODAY , ".rds"))






