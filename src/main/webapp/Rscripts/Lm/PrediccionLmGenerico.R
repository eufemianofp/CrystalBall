#===========================================#
#		 		 PREDICCIÓN 				#
#			    LM GENÉRICO					#
#===========================================#

#Definición:
#	Esta función realiza una predicción mediante un modelo lineal, ofreciendo valores máximos y mínimos de acuerdo a un intervalo de confianza
#	que escogerá el usuario. Además, también muestra la probabilidad de aprobar de los alumnos.

#Parámetros de entrada:
	#Base: un data.frame que contiene toda la información necesaria sobre los alumnos de años anteriores.(Es sobre la que se basa el modelo lineal).
	#Primero: data.frame que contiene la información obtenida en un determinado tiempo sobre los alumnos de Primero.
	#asignatura: asignatura sobre la que se va a realizar la predicción.
	#a: TRUE si hay NA en la Base.
	#	FALSE si la Base está imputada.
	#conf:intervalo de confianza para establecer los valores máximos y mínimos.
	
#Parámetros de salida:
	#Devuelve un data frame con la predicción, nota máxima, nota mínima y probabilidad de aprobar.
	
#Funciones necesarias:
	#BaseGenerico,glmGenerico, ParapredecirGenerico, PorcAprobado
	
#Requisitos indispensables para que funcione:
	#-Deben cumplirse todos los requisitos de las funciones necesarias (así como haber cargado las funciones necesarias que tienen las propias funciones 
	# necesarias de esta función
		
#Ejemplo:
	#Prediccion<-PrediccionLmGenerico(Base,FinalesNoviembre,"Matematicas",TRUE,0.8)
PrediccionLmGenerico<-function(Base,Primero,asignatura,a,conf)
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
	if(length(Incluir)==1)
	{
		colnames(ConAsig)[1]<-colnames(BaseGen)[Incluir]
	}
	lmFit<-lm(asignatura~.,data=ConAsig)
	PrimeroFin<-ParaPredecirGenerico(Base,Primero) #Datos de Primero de la manera correcta para predecir
	Predecir <- as.data.frame(PrimeroFin[,Incluir])
	if(length(Incluir)==1)
	{
		colnames(Predecir)[1]<-colnames(BaseGen)[Incluir]
	}
	Prediccion<-predict(lmFit,Predecir,level=conf,interval="prediction",se.fit=TRUE)
	PredConAprob<-PorcAprobado(Prediccion,conf)
	return(PredConAprob)
}