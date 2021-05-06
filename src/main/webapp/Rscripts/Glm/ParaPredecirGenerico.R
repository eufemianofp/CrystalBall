
#===========================================#
#				PARA PREDECIR 				#
#			   GLMNET GENÉRICO				#
#===========================================#

#Definición:
#	Esta función devuelve el data.frame correspondiente a los alumnos de primero curso, de la manera adecuada para poder hacer posteriormente la predicción.

#Parámetros de entrada:
	#Base: un data.frame que contiene toda la información necesaria sobre los alumnos de años anteriores.(Es sobre la que se va a basar el cv.glmnet)
	#Primero: data.frame que contiene la información obtenida en un determinado tiempo sobre los alumnos de Primero.
	
#Parámetros de salida:
	#Devuelve el data.frame que se quiere predecir, pero con las mismas columnas con las que se ha hecho el cv.glmnet para que se pueda
	#realizar la predicción.
	
#Funciones necesarias:
	#SeleccionColumnas, SeparareImputar, SepararFactores
	
#Requisitos indispensables para que funcione:
	#-Deben cumplirse todos los requisitos de las funciones necesarias.
		
#Ejemplo:
	#PrimeroCorregido<-ParaPredecirGenerico(Base,FinalesNoviembre)
	
ParaPredecirGenerico<-function(Base,Primero)
{
	Primero<-SeleccionColumnas(Primero) #Selección de las columnas que no están vacías
	Primero<-Primero[,which(colnames(Primero)!="Carnet")] #se omiten los Carnet
	Base<-Base[,colnames(Primero)] #Se escojen las columnas de Base que coinciden con las de Primero
	junto<-rbind(Base,Primero) #se junta Base y Primero
	junto<-SeparareImputar(junto) #se imputa los valores que son NA
	junto<-SepararFactores(junto) #se hace el model.matrix para los factores y se unen las columnas numéricas
	junto<-junto[(nrow(Base)+1):nrow(junto),] #Se escogen únicamente los valores asociados a primero.
	junto<-apply(as.matrix(junto),2,as.numeric) #clase as.numeric
	return(junto)
}
