
#===========================================#
#				MODELO GLMNET				#
#				  GENÉRICO					#
#===========================================#

#Definición:
#	Esta función realiza un cv.glmnet con los datos disponibles dada una fecha determinada.

#Parámetros de entrada:
	#Base: un data.frame que contiene toda la información necesaria sobre los alumnos de años anteriores.
	#Primero: data.frame que contiene la información obtenida en un determinado tiempo sobre los alumnos de Primero.
	#asignatura: asignatura sobre la que se quiere hacer el cv.glmnet.
	#a: TRUE si Base tiene NA.
	#	FALSE si Base está imputado.
	
#Parámetros de salida:
	#Devuelve el cv.glmnet
	
#Funciones necesarias:
	#BaseGenerico
	
#Requisitos indispensables para que funcione:
	#-El nombre de la asignatura debe corresponderse con las asignaturas disponibles.
	#-Deben cumplirse todos los requisitos de las funciones necesarias.
	
#Librerías:
	#Es necesaria la librería glmnet para hacer cv.glmnet
	
#Ejemplo:
	#cvFit<-glmGenerico(Base,FinalesNoviembre,"Matematicas",TRUE)

	
glmGenerico<-function(Base,Primero,asignatura,a)
{
	require('glmnet')
	BaseGen<-BaseGenerico(Base,Primero,asignatura,a) #Obtención de la Base de la manera correcta para predecir
	BaseSinAsign<-BaseGen[,which(colnames(BaseGen)!=asignatura)] #Se quita la asignatura
	cvFit<-cv.glmnet(apply(as.matrix(BaseSinAsign),2,as.numeric),BaseGen[,asignatura],family="gaussian",alpha=0.9) #Se hace el cv.glmnet, con un alpha de 0.9
	return(cvFit)
}



