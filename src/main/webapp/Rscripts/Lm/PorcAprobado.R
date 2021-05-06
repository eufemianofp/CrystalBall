#===========================================#
#		 		 PROBABILIDAD				#
#			  	  DE APROBAR				#
#===========================================#

#Definición:
	#Está función nos dice las posibilidades que tiene una persona de aprobar una determinada asignatura.
	
#Parámetros de entrada:
	#prediccion:data frame con los datos de las predicciones (nota predicha, máxima y mínima) sobre una o varias personas
	#conf: indica el grado de confianza con el que lo vamos a calcular
	
#Parámetro de salida:
	#Devuelve la variable de entrada pero añadiéndole una columna con la probabilidad de aprobar.
	
#Ejemplo:
	#PredConAprobado<-PorcAprobado(prediccion,0.8)

PorcAprobado<-function(prediccion,conf)
{
	desv<-(prediccion$fit[,1]-prediccion$fit[,2])/qt(1-((1-conf)/2), prediccion$df)
	normal<-(5-prediccion$fit[,1])/desv
	prob<-1-pt(normal, prediccion$df)
	prob<-prob*100
	PorcAprob<-cbind(prob, prediccion$fit)
	return(PorcAprob)
}
