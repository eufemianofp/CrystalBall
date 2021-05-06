#=======================================#
#	 		TABLA DE ASIGNATURAS		#
#			CON LOS PORCENTAJES 		#
#=======================================#
#Definición:
	#Esta función realiza una tabla con el porcenaje de gente que ha sacado sobresaliente, notable, aprobado o suspenso. Lo hace para el primer semestre,
	#el segundo y los dos juntos (según la opción que se elija), y también se puede escoger un curso determinado.
	
#Parámetros de entrada:
	#Base: datos sobre los que se va a realizar la tabla
	#Curso: curso con el que se quiere hacer la tabla. Escribir "todos" si se quiere realizar de todos los cursos disponibles.
	#tipo: "PrimerSemestre": si se quiere realizar con las asignaturas del primer semestre.
	#	   "SegundoSemestre": si se quiere realizar con las asignaturas del segundo semestre.
	#	   "todos": si se quiere realizar con las asignaturas de ambos semestres.

#Parámetros de salida:
	#Devuelve un data.frame con los porcentajes en cada una de las asignaturas

#Ejemplo:
	#Tabla<-TablaNotasAsignaturas(Base,"2012-2013","PrimerSemestre")
	
TablaNotasAsignaturas<-function(Base,Curso,tipo)
{
	if(tipo=="PrimerSemestre")
	{
		asignaturas<-c("Matematicas","Fisica","Informatica","Antropologia","ECC")
	}
	if(tipo=="SegundoSemestre")
	{
		asignaturas<-c("MatematicasII","FisicaII","Estadistica","EconomiayEmpresa","AntropologiaII","ECCII")
	}
	if(tipo=="Todas")
	{
		asignaturas<-c("Matematicas","Fisica","Informatica","Antropologia","ECC","MatematicasII","FisicaII","Estadistica","EconomiayEmpresa","AntropologiaII","ECCII")
	}
	if(Curso!="Todos")
	{
		Base<-Base[which(Base[,"Curso"]==Curso),]
	}
	for(i in 1:length(asignaturas))
	{
		notas<-Base[,asignaturas[i]]
		sobresalientes<-(tabulate(tabulate(which(notas>=9)))/length(notas))*100
		notables<-(tabulate(tabulate(intersect(which(notas<9),which(notas>=7))))/length(notas))*100
		aprobados<-(tabulate(tabulate(intersect(which(notas<7),which(notas>=5))))/length(notas))*100
		suspensos<-(tabulate(tabulate(which(notas<5)))/length(notas))*100
		tabla<-data.frame(Asignatura=asignaturas[i],SB=sobresalientes,NT=notables,AP=aprobados,SS=suspensos)
		if(i==1)
		{
			tablaGeneral<-tabla
		}
		if(i!=1)
		{
			tablaGeneral<-rbind(tablaGeneral,tabla)
		}
	}
	return(tablaGeneral)
}