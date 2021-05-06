#=======================================#
#	 			GENERAR TABLA			#
#		  		PREDICCIONES			#
#=======================================#
#Definición:
	#Esta función nos proporciona un data.frame con las predicciones para todas las asignaturas del primer o segundo semestre para todos los alumnos.
	#Proporciona la nota esperada, la máxima posible, la mínima posible y la probabilidad de aprobar para el intervalo de confianza que el usuario escoja,
	#realizando un modelo concorde a los datos con los que se dispone.
	
#Parámetros de entrada:
	#Base:todos los datos sobre los cursos anteriores.
	#Primero: los datos disponibles sobre los alumnos a predecir.
	#conf: entre 0 y 1, el grado de confianza para calcular los intervalos de la nota máxima y mínima.
	#opcion: "PrimerSemestre": para que devuelva las predicciones del primer semestre.
	#				 "SegundoSemestre": para que devuelva las predicciones del segundo semestre.

#Parámetros de salida:
	#Un data.frame que contiene las predicciones de los alumnos de primero para todas las asignaturas del primer o del segundo semestre (nota esperada, máxima posible, 
	#mínima posible y probabilidad de aprobar)
	
#Funciones necesarias: (SEGUIR CORRIGIENDO)
	#PrediccionGlmGenerico, glmGenerico, ParapredecirGenerico, BaseGenerico, SeleccionColumnas, SeparareImputar, ImputeValues, SepararFactores
	#PrediccionLmGenerico , LmGenerico, PorcAprobado
	
#Requisitos indispensables para que funcione: 
	#-Las columnas deben de ser de clase factor o numéricas.
	#-Para que se tenga en cuenta una columna de Primero, deberá haber menos del 60% de NA en esa columna.
	#-En el parámetro de entrada Base, no podrá haber ningún NA asociado a una columna de clase numérica.
	
#Ejemplo:
	#pwd<-"C:/Users/Ángel Fuertes/Desktop/Universidad/Dropbox/CrystalBall"	
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/QuitarNa/1 ImputeValues.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/QuitarNa/2 SeparareImputar.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Glm/SepararFactores.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Glm/SeleccionColumnas.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Glm/BaseGenerico.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Glm/GlmGenerico.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Glm/ParaPredecirGenerico.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Glm/PrediccionGlmGenerico.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Lm/PorcAprobado.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Lm/LmGenerico.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/Lm/PrediccionLmGenerico.R",pwd))
	#Tabla<-GenerarTablaPredicciones(Base,FinalesNoviembre,0.8,"PrimerSemestre")


GenerarTablaPredicciones<-function(Base,Primero,conf,opcion)
{
	if(opcion=="PrimerSemestre")
	{
		Asignaturas<-c("Matematicas","Fisica","Informatica","Antropologia","ECC")
		columnNames<-c("Carnet","MatEsp","MatMin","MatMax","MatProb","FisEsp","FisMin","FisMax","FisProb","InfEsp","InfMin","InfMax","InfProb","AntEsp","AntMin","AntMax","AntProb","ECCEsp","ECCMin","ECCMax","ECCProb")
	}else if(opcion=="SegundoSemestre"){
		Asignaturas<-c("MatematicasII","FisicaII","Estadistica","EconomiayEmpresa","AntropologiaII","ECCII")
		columnNames<-c("Carnet","MatIIEsp","MatIIMin","MatIIMax","MatIIProb","FisIIEsp","FisIIMin","FisIIMax","FisIIProb","EstEsp","EstMin","EstMax","EstProb","EcoEsp","EcoMin","EcoMax","EcoProb","AntIIEsp","AntIIMin","AntIIMax","AntIIProb","ECCIIEsp","ECCIIMin","ECCIIMax","ECCIIProb")
	}
	
	for (i in 1:length(Asignaturas))
	{
		asignatura<-Asignaturas[i]
		PrediccionLm<-PrediccionLmGenerico(Base,Primero,asignatura,FALSE,conf)
		PrediccionGlm<-PrediccionGlmGenerico(Base,Primero,asignatura,FALSE)
		PrediccionLm[,"fit"]<-PrediccionGlm
		PrediccionLm<-PrediccionLm[,c("fit","lwr","upr","prob")]
		if(i==1) Tabla<-PrediccionLm
		
		if(i!=1) Tabla<-cbind(Tabla,PrediccionLm)
	}

	Tabla<-cbind(Primero[,"Carnet"],Tabla)
	colnames(Tabla)<-columnNames

	return(Tabla)
}
