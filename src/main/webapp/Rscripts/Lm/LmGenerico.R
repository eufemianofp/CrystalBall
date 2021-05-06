
#===========================================#
#				MODELO LINEAL				#
#				  GENÉRICO					#
#===========================================#

#Definición:
#	Esta función realiza un modelo lineal con los datos disponibles dada una fecha determinada.

#Parámetros de entrada:
	#Base: un data.frame que contiene toda la información necesaria sobre los alumnos de años anteriores.
	#Primero: data.frame que contiene la información obtenida en un determinado tiempo sobre los alumnos de Primero.
	#asignatura: asignatura sobre la que se quiere hacer el cv.glmnet.
	#a: TRUE si Base tiene NA.
	#	FALSE si Base está imputado.
	
#Parámetros de salida:
	#Devuelve el modelo lineal.
	
#Funciones necesarias:
	#BaseGenerico,ParaPredecirGenerico,glmGenerico
	
#Requisitos indispensables para que funcione:
	#-El nombre de la asignatura debe corresponderse con las asignaturas disponibles.
	#-Deben cumplirse todos los requisitos de las funciones necesarias.
	
#Ejemplo:
	#lmFit<-lmGenerico(Base,FinalesNoviembre,"Matematicas",TRUE)



lmGenerico<-function(Base,Primero,asignatura,a)
{
	BaseGen<-BaseGenerico(Base,Primero,asignatura,a)
	PrimeroGen<-ParaPredecirGenerico(Base,Primero)
	cvFit<-glmGenerico(Base,Primero,asignatura,a)
	Params <- as.vector(coef(cvFit))
	Params<-Params[-1]
	Incluir <- which(abs(Params)>1e-6)
	Baselm <-BaseGen[,Incluir]
	ConAsig<-cbind(Baselm,BaseGen[,asignatura])
	colnames(ConAsig)[ncol(ConAsig)]<-"asignatura"
	ConAsig<-as.data.frame(ConAsig)
	lmFit<-lm(asignatura~.,data=ConAsig)
	return(lmFit)
}
