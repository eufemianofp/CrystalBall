
#===========================================#
#		SEPARAR LOS LEVELS DE CADA UNO		#
#		DE LOS FACTORES POR COLUMNAS		#
#===========================================#

#Definición:
#	Esta función separa por columnas cada uno de los levels de una columna de clase factor. Hace lo mismo que model.matrix
#	sólo que separa aquellos datos de clase numeric para hacerlo y posteriormente los junta al final.
#	Comunicación II

#Parámetros de entrada:
	#Un data.frame con columnas clase Factor y clase Numeric
	
#Parámetros de salida:
	#Un data.frame con las mismas columnas clase numeric que al principio, y cada una de las columnas clase Factor, las ha separado en sus diferentes levels
	#por columnas (model.matrix)
	
#Requisitos indispensables para que funcione:
	#La clase de las columnas debe ser tipo factor y numeric.
	
#Ejemplo:
	#Todo<-SepararFactores(Todo)
	
SepararFactores<-function(x)
{
	Numeros <- which(sapply(x,class)=="numeric") #columnas con clase numeric
	Factores <- which(sapply(x,class)!="numeric") #columnas con clase diferente a numeric
 	Numeros<-x[,Numeros] 
 	Factores<-x[,Factores]

	base<-model.matrix(~.,Factores)[,-1] #Separa por columnas cada uno de los levels de cada columna de Factores.
	Base<-cbind(Numeros,base) #Se junta con los datos numéricos.
	return(Base)		
}