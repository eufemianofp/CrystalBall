#=======================================#
#	 	BOXPLOT SEGÚN TITULACIÓN, 		#
#		POR ASIGNATURA Y AÑO		#
#=======================================#
#Definición:
	#Esta función muestra un boxplot de las calificaciones en una asignatura dependiendo del grado escogido en un año determinado.
	
#Parámetros de entrada:
	#Todo: datos sobre los que se va a realizar el boxplot.
	#asignatura: asignatura con la que se quiere hacer el boxplot.
	#Curso: curso con el que se quiere hacer el boxplot. Escribir "todos" si se quiere realizar de todos los cursos disponibles.

#Parámetros de salida:
	#Vacío (aunque muestra el boxplot por pantalla)

#Ejemplo:
	#dibAsigTit(Todo,"Matematicas","2012-2013")
dibAsigTit<-function(Todo,asignatura,Curso)
{
	if (Curso!="todos") Todo<-Todo[which(Todo[,"Curso"]==Curso),]
	boxplot(Todo[,asignatura]~Todo[,"Plan"],las=2,col=c(2:8,"pink","orange"),ylab=Curso,main=asignatura)
	tableData <- as.data.frame(Todo[,asignatura]);
	colnames(tableData)[1] <- asignatura;
	return(tableData);
}