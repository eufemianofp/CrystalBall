#=======================================#
#		 NOTAS FINALES DE LAS			#
#			 ASIGNATURAS				#
#=======================================#

#Definición:
	# Esta función nos proporciona la nota que han obtenido los alumnos en las asignaturas en una convocatoria
	# indicada.

#Parámetros de entrada:
	# Calificaciones: un data.frame en el que están guardados los siguientes datos de los alumnos: Carnet, 
	# 				  Asignaturas, Calificación numérica y Tipo de convocatoria 
	#convocatoria:    "Ordin" si se quiere escoger la ordinaria o "Extra" si se quiere la extraordinaria.
	#asignatura: 	  escribir  "todas" si queremos obtener las calificaciones de todas las asignaturas. En 
	#				  caso de interesarnos una sola asignatura introducir su nombre. Las asignaturas son: 
	#				  "Matemáticas","Física","Informática","Antropología","Formación General Común","Fisica II",
	#				  "Matemáticas II","Economía y Empresa","Estadística y Probabilidad","Formación General 
	#				  Común II","Antropología II"
	
#Parámetros de salida:
	#Devuelve un data.frame con las siguientes columnas: el número de Carnet de alumno, y cada una de las asignaturas.
	#En las filas está cada alumno con su respectivo carnet y calificación en cada asignatura.

#Requisitos indispensables para que funcione:
		#-Las columnas deben tener los siguientes nombres: "CARNET","ASIGNATURA","CALIFICACION_NUMERICA","TIPO_CONVOCATORIA".
		
#Librerías:
	#Es necesario utilizar la librería reshape2 para la función dcast
	
#Ejemplo:
	#NotasAlumnos<-notfin(Calificaciones,"Ordin","todas")
	

notfin<-function(Calificaciones,convocatoria,asignatura)
{
	suppressPackageStartupMessages(library('reshape2'))
	
	Filtro <- which(Calificaciones[,"TIPO_CONVOCATORIA"]==convocatoria) #Escogemos la convocatoria que nos interesa
	NotasFinales <- dcast(Calificaciones[Filtro,], CARNET ~ ASIGNATURA, #con la función dcast nos proporciona un data.frame 
																		#con los alumnos y sus calificaciones en las asignaturas
                value.var="CALIFICACION_NUMERICA", 
                fun.aggregate=mean)
	if(asignatura!="todas") #En caso de querer una sola asignatura
	{
		NotasFinales<-NotasFinales[,c("CARNET",asignatura)]
	}
	
	return(NotasFinales)
}

