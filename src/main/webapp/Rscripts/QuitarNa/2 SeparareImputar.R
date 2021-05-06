
#===========================================#
#  		SEPARAR EN FACTORES Y NUMÉRICOS		#
#		E IMPUTAR LOS VALORES NUMÉRICOS		#
#===========================================#

#Definición:
#	Esta función imputa los valores numéricos que hay en un data.frame

#Parámetros de entrada:
	#Un data.frame con columnas clase Numeric y otras clases
	
#Parámetros de salida:
	#Un data.frame como el de la entrada pero con los valores NA imputados.
	
#Funciones necesarias:
	#imputeValues
	
#Requisitos indispensables para que funcione:
	#-La clase de las columnas debe ser tipo factor y numeric.
	#-No debe haber una columna con excesivos NA
	
#Ejemplo:
	#Todo<-SeparareImputar(Todo)
SeparareImputar<-function(Base)
{
  # impute_installed <- suppressPackageStartupMessages(require('impute'))
  # if (!impute_installed) install.packages('impute')
  
	Numeros <- which(sapply(Base,class)=="numeric") #columnas clase numeric
	Factores <- which(sapply(Base,class)!="numeric") #columnas clase diferente a numeric
 	Numeros<-Base[,Numeros] #Se guardan los valores anteriores en Numeros
 	Factores<-Base[,Factores] #Se guardan los valores anteriores en Factores
	Numeros<-imputeValues(Numeros,3) #Se imputa
	Base<-cbind(Numeros$data,Factores) #Se junta de nuevo
	return(Base)		
}