
#===========================================#
#					PLOT	 				#
#		NOTAS PREDICHAS-NOTAS REALES		#
#===========================================#

#Definición:
#	Esta función dibuja una gráfica indicando la relación entre la nota predicha para un alumno y la nota que realmente ha sacado.

#Parámetros de entrada:
	#prediccion: la nota predicha para los alumnos.
	#Primero: data.frame que contiene la nota obtenida en las diferentes asignaturas de los alumnos de primero.
	#asignatura: la asignatura a analizar.
	
#Parámetros de salida:
	#vacío (únicamente muestra la gráfica por pantalla)
		
#Ejemplo:
	#PlotGlm(prediccion,Primero,"Matematicas")
PlotGlm<-function(prediccion,Primero,asignatura,nombre)
{
	DatosAsignaturaSinNa<-which(is.na(Primero[,asignatura])==FALSE)
	prediccion<-prediccion[DatosAsignaturaSinNa]
	plot(prediccion,Primero[DatosAsignaturaSinNa,asignatura],xlab="Prediccion",ylab=asignatura,main=nombre)
	abline(a=0,b=1,col="red")
	tableData <- as.data.frame(Primero[DatosAsignaturaSinNa,asignatura]);
	colnames(tableData)[1] <- asignatura
	return(tableData);
}


