## RESET
rm(list= ls())
graphics.off()
cat('\014')


# ############################################################################ #
#
## DESCRIPCIÓ:    Script per calcular estadístiques de cobatest core.  
#
## VERSIO:  13-02-2024
#
# ############################################################################ #


library(data.table)

TODAY <- format(Sys.Date(), '%Y%m%d') 


# Parametres per seleccionar el mes i any que volem processar. 
YEAR <- '2024'
MONTH <- '01'


# ---------------------------------------------------------------------------- #
# LOAD DATA                                                                 ####       
# ---------------------------------------------------------------------------- #

# Nom del fitxer
FILE <- grep(x = list.files("data/cobatest_export/"), pattern = paste0(MONTH,'_',YEAR), fixed = T, value = T)

coba <- setDT(readRDS(paste0("data/cobatest_export/",FILE)))
cat(paste(colnames(cobatest_export), collapse = '\n'))








