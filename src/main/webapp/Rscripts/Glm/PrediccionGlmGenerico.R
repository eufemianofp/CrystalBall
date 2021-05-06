#===========================================#
#		 		 PREDICCIÓN 				#
#			   GLMNET GENÉRICO				#
#===========================================#

#Definición:
#	Esta función realiza una predicción mediante cv.glmnet

#Parámetros de entrada:
	#Base: un data.frame que contiene toda la información necesaria sobre los alumnos de años anteriores.(Es sobre la que se va a basar el cv.glmnet).
	#Primero: data.frame que contiene la información obtenida en un determinado tiempo sobre los alumnos de Primero.
	#asignatura: asignatura sobre la que se va a realizar el modelo predictivo.
	#a: TRUE si hay NA en la Base
	#	FALSE si la Base está imputada.
	
#Parámetros de salida:
	#Devuelve la predicción realizada
	
#Funciones necesarias:
	#glmGenerico, ParapredecirGenerico
	
#Requisitos indispensables para que funcione:
	#-Deben cumplirse todos los requisitos de las funciones necesarias (así como haber cargado las funciones necesarias que tienen las propias funciones 
	# necesarias de esta función
		
#Ejemplo:
	#Prediccion<-PrediccionGlmGenerico(Base,FinalesNoviembre,"Matematicas",TRUE)

PrediccionGlmGenerico<-function(Base,Primero,asignatura,a)
{
	cvFit<-glmGenerico(Base,Primero,asignatura,a) #modelo cv.glmnet
	DatosPrimero<-ParaPredecirGenerico(Base,Primero) #Datos de Primero de la manera correcta para predecir
	prediccion<-predict(cvFit,DatosPrimero) #predicción
	return(prediccion)
}


