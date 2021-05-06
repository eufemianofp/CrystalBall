#=======================================#
#	 	BOXPLOT NOTAS DE ASIGNATURAS	#
#			EN FUNCION DEL CURSO		#
#=======================================#
#Definición:
	#Esta función muestra un boxplot de las calificaciones en una o varias asignaturas en función del curso escogido.
	
#Parámetros de entrada:
	#Todo: datos sobre los que se va a realizar el boxplot.
	#asignatura: asignatura con la que se quiere hacer el boxplot.
	#			 Si se quiere graficar úniciamente una asignatura, escribir su nombre.
	#			 Escribir: "PrimerSemestre si se quiere graficar todas las notas del Primer Semestre.
	#			 Escribir: "Segundo Semestre si se quiere graficar todas las notas del Segundo Semestre.
	#Curso: curso con el que se quiere hacer el boxplot.

#Parámetros de salida:
	#Vacío (aunque muestra el boxplot por pantalla)

#Ejemplo:
	#AsigCurso(Todo,"PrimerSemestre","2012-2013")


AsigCurso<-function(Todo,asignatura,Curso)
{
	Todo<-Todo[which(Todo[,"Curso"]==Curso),]
	if (asignatura=="PrimerSemestre")
	{
		finMat1<-as.matrix(Todo)
		finMat1<-finMat1[,c("Matematicas","Fisica","Informatica","Antropologia","ECC")]
		finMat1<-apply(finMat1,2,as.numeric)
		boxplot(finMat1,las=2,col=2:6,main=Curso)
		tableData <- finMat1;
	}
	if (asignatura=="SegundoSemestre")
	{	
		finMat1<-as.matrix(Todo)
		finMat1<-finMat1[,c("MatematicasII","FisicaII","Estadistica","EconomiayEmpresa","AntropologiaII","ECC")]
		finMat1<-apply(finMat1,2,as.numeric)
		boxplot(finMat1,las=2,col=2:7,main=Curso)
		tableData <- finMat1;
	}	
	if (asignatura!="PrimerSemestre" && asignatura!="SegundoSemestre") 
	{
		tableData <- Todo[,asignatura];
		boxplot(tableData,las=2,col=4,main=asignatura)
	}
	tableData <- as.data.frame(tableData);
	colnames(tableData)[1] <- asignatura;
	return(tableData);
}
