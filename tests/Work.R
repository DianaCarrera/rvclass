# Work.R 
# This file create, generate the documentation, validate the package according to
# R standards, and install the package
# ------------------------------------------
#
# Work.R se ejecuta dentro del directorio del propio paquete. 
# El directorio tiene la siguiente estructura:
# test, R, NAMESPACE, man, inst, DESCRIPTION, and data.

require('devtools')

rm(list = ls(all.names=TRUE))  # Borra todas las variables del workspace

load_all("./")      # Crea el paquete.
# test('./')        # Ejecuta las pruebas unitarias. No hay pruebas unitarias, por eso esta comentado
document('./')      # Compila y genera la documentación autimaticamente.
check('./')         # Valida el paquete según los estándares de R.
devtools::build()   # Crea el paquete.
devtools::install() # Instala el paquete.
      