# Proyecto de R Ejemplo para integrar con LaTeX
# Curso LaTeX ECEL
# Daniel Sánchez

# Cargar dataframe (base de datos)
df<-read.csv('df.csv')

# Mediante el paquete stargazer, puedo sacar estadística descriptiva fácilmente, e importar a latex
# Es necesario instalarlo, y cargarlo
# install.packages('stargazer')
library(stargazer)
# Ahora, mediante el nuevo comando stargazer calculo estadística descriptiva de cualquier dataframe
stargazer(df, title='Estadística Descriptiva')

# Es demasiado larga, quito algunas variables, creando una base especial de solo las variables que quiero
# Necesito un comando dentro del grupo de paquetes tidyverse
library(tidyverse)
df_mod<-select(df, efw, cpi, reg, gdp_pc, pol, inf,agedem) # selecciono solo algunas variables
var_names<-c('Economic Freedom Index', 'Corruption Perceptions Index', 
             'Regulation Score', 'GDP per Capita', 
             'Polity IV', 'Inflation', 'Age of Democracy') # creo un vector con nombres de variables

# Ahora si el comando stargazer con diferentes argumentos

stargazer(df_mod, 
          title='Estadística Descriptiva de solo Algunas Variables', 
          omit.summary.stat=c('max', 'min'), covariate.labels = var_names, 
          notes='Todas las variables son del 2015') 

# Hago unas regresiones para exportarlas

reg1<-lm(cpi~efw+reg+pol+agedem, data=df)
reg2<-lm(cpi~efw+reg+pol+agedem+inf+oil, data=df)
reg3<-lm(cpi~efw+reg+pol+agedem+inf+oil+oil*efw, data=df)

stargazer(reg1,reg2,reg3)

# Para utilizar errores robustos a heterocedasticidad
# Primero debo calcularlos, usar el paquete sandwich

library(sandwich)
cov1<-vcovHC(reg1,type='HC1')
se1<-sqrt(diag(cov1))

cov2<-vcovHC(reg2,type='HC1')
se2<-sqrt(diag(cov2))

cov3<-vcovHC(reg3,type='HC1')
se3<-sqrt(diag(cov3))

stargazer(reg1,reg2,reg3, se=list(se1,se2,se3), omit.stat=c('ser', 'f'))
