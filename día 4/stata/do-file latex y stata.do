/* Incorporando LaTeX con Stata
Do-file para generar output de Stata utilizable en LaTeX*/

version 15
set more off
capture log close
log using ltxstat, replace

clear 
*borra todo lo que estaba cargado anteriormente

use corruption.dta
*cargar la base

* El comando version 15 asegura compatibilidad con otras versiones de Stata

*Para exportar requiero instalar el paquete, si es que no estaba installado debo hacer ssc install outreg2

summarize
* Para hacer estadística descriptiva de todas las variables en la base que quedó cargada
* Para exportar basta pegarlo a Excel como una tabla

reg cpi efw reg pol agedem 
* Regresión no. 1 
outreg2 using results, replace tex dec(2)
* outreg2 es el comando, utiliza un archivo de tex que se llama results y pone 2 decimales. Hace replace para vaciar todo lo que estaba en ese tex, si es que había algo

reg cpi efw reg pol agedem inf oil 
* Regresión no. 2
outreg2 using results, append tex dec(2)
* Lo mismo pero ahora va a unir la de ahora, con la que estaba anteriormente. 

gen int_oilefw= efw*oil
* Generando término de interacción
reg cpi efw reg pol agedem inf oil int_oilefw
* Regresión no. 3
outreg2 using results, append tex dec(2)
* Igual que antes

* Exportar a Excel sería exactamente lo mismo pero reemplazar Excel por TEX

reg cpi efw reg pol agedem 
* Regresión no. 1 
outreg2 using results, replace excel dec(2)
* outreg2 es el comando, utiliza un archivo de  excel que se llama results y pone 2 decimales. Hace replace para vaciar todo lo que estaba en ese excel, si es que había algo

reg cpi efw reg pol agedem inf oil 
* Regresión no. 2
outreg2 using results, append excel dec(2)
* Lo mismo pero ahora va a unir la de ahora, con la que estaba anteriormente. 

reg cpi efw reg pol agedem inf oil int_oilefw
* Regresión no. 3
outreg2 using results, append excel dec(2)
* Igual que antes


log close
exit

