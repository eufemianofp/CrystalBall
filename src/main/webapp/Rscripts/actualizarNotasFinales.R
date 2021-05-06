#=======================================#
#	 DEJAR LOS DATOS CORRECTAMENTE		#
#		   EN UN DATA.FRAME 			#
#=======================================#
#Definición:
	#Esta función nos proporciona un data.frame añadiendo los datos nuevos de un año a los datos que se tenía anteriormente.
	
#Parámetros de entrada:
	#Datos.Personales: un data frame que contiene información de los datos personales de los alumnos.
	#Calificaciones: un data frame que contiene información sobre las calificaciones de los alumnos.
	#PEQ.y.Parciales: un data frame que contiene por columnas: números de carnet, nombre de los PEQ, la nota, sobre cuánto es esa nota y el Curso
	#path: dirección de los exámenes de admisión.
	#Curso:Curso que se va a introducir
	#Base:todos los datos sobre los cursos anteriores.

#Parámetros de salida:
	#Un data.frame que contiene toda la información actualizada de los alumnos
	
#Funciones necesarias:
	#notfin, DiferenciarAyete, notaspeq, IntroducirExAdmision, ComunidadesAutonomas, ImputeValues, SeparareImputar
	
#Requisitos indispensables para que funcione:
	#Deben cumplirse todos los requisitos necesarios para cada una de las funciones a utilizar.
	
#Ejemplo:
	#pwd<-"C:/Users/Ángel Fuertes/Desktop/Universidad/Dropbox/CrystalBall"	
	##source(sprintf("%s/Alvaro/Proyecto/FINAL/CargarDatos.R",pwd))
	##source(sprintf("%s/Alvaro/Proyecto/FINAL/GenerarMatrizUltima/2 NotasFinalesAsignaturas.R",pwd))
	##source(sprintf("%s/Alvaro/Proyecto/FINAL/GenerarMatrizUltima/3 DiferenciarAyete.R",pwd))
	##source(sprintf("%s/Alvaro/Proyecto/FINAL/GenerarMatrizUltima/4 notaspeq.R",pwd))
	##source(sprintf("%s/Alvaro/Proyecto/FINAL/GenerarMatrizUltima/5IntroducirExAdmision.R",pwd))
	##source(sprintf("%s/Alvaro/Proyecto/FINAL/GenerarMatrizUltima/6 ComunidadesAutonomas.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/QuitarNa/1 ImputeValues.R",pwd))
	#source(sprintf("%s/Alvaro/Proyecto/FINAL/QuitarNa/2 SeparareImputar.R",pwd))
	#filePath<-"C:/Users/Ángel Fuertes/Desktop/Universidad/Dropbox/CrystalBall/arubio_Datos_Nuevos_a_Primero_20140310_nonames.xlsx"
	#perlPath <- "C:/strawberry/perl/bin/perl.exe"
	#path<-"C:/Users/Ángel Fuertes/Desktop/Universidad/Dropbox/CrystalBall/DatosExamenesAdmision13/"
	##Datos.Personales<-CargarDatos(filePath,perlPath,1) #Se cargan  los Datos Personales desde el 2010-2011 hasta el 2013-2014
	##Calificaciones <- CargarDatos(filePath,perlPath,2)#Se cargan  las Calificaciones desde el 2010-2011 hasta el 2013-2014
	##PEQ.y.Parciales <- CargarDatos(filePath,perlPath,3) #Se cargan los datos de los PEQ y Parciales del curso 2013-2014
	##Curso<-"2013-2014"
	#Todo<-ActualizarDatos(Datos.Personales,Calificaciones,PEQ.y.Parciales,path,Curso,Base)
	
ActualizarDatos<-function(Datos.Personales,Calificaciones,PEQ.y.Parciales,path,Curso,Base)
{
	Calificaciones<-Calificaciones[which(Calificaciones[,"CURSO"]==Curso),]
	Datos.Personales<-Datos.Personales[which(Datos.Personales[,"CURSO"]==Curso),]
	NotasAlumnos<-notfin(Calificaciones,"Ordin","todas") #Se deja las notas de los alumnos ordenadas en NotasAlumnos
	Datos<-DiferenciarAyete(Datos.Personales)#Información adicional sobre C.M.Ayete
	NotasPeq <- suppressWarnings(notaspeq(PEQ.y.Parciales,Curso)) #Se deja en NotasPeq las notas de los peq del curso correspondiente de manera ordenada
	
	Datos <- suppressWarnings(IntroducirExAdmision(Datos,path)) #Se introducen los examenes de admisión
	
	Datos<-Datos[,c("CARNET","CURSO","SEXO","PLAN","CALIFICACION_PAU","CENTRO_BACHILLERATO","PROV_DOM_FAM","PAIS_DOM_FAM","Alojamiento","NOTA_FIS","NOTA_MATE")] 
	#Se selecciona las columnas que interesan, y se les cambia el nombre por el que se va a utilizar para la aplicación.
	colnames(Datos)<-c("Carnet","Curso","Sexo","Plan","PAU","Colegio","Provincia","Pais","Alojamiento","PrevioFisica","PrevioMates")

	NotasAlumnos<-NotasAlumnos[,c("CARNET","Matemáticas","Informática","Física","Antropología","Estrategias de Conocimiento y Comunicación","Matemáticas II","Física II","Estadística y Probabilidad","Economía y Empresa","Antropología II","Estrategias de Conocimiento y Comunicación II")]
	#Se hace lo mismo pero con NotasAlumnos.
	colnames(NotasAlumnos)<-c("Carnet","Matematicas","Informatica","Fisica","Antropologia","ECC","MatematicasII","FisicaII","Estadistica","EconomiayEmpresa","AntropologiaII","ECCII")

	colnames(NotasPeq)[which(colnames(NotasPeq)=="CARNET")]<-"Carnet" #Se cambia el nombre de la primera columna para que "Carnet" tenga el mismo nombre en todos los data.frame
	Datos<-ComunidadesAutonomas(Datos) #Se añaden las ComunidadesAutonomas
	DatyNot<-merge(Datos,NotasAlumnos,by="Carnet") #se juntan Datos y NotasAlumnos por el número de Carnet.
	#Ahora se va a proceder a juntar los datos personales y las calificaciones con los peq y parciales
	#Pero no se puede utilizar un merge puesto que si no perdería información sobre todos
	#aquellos que no tenemos la información de los peq. Por ello, hacemos lo siguiente:

	#Se relaciona la posición de DatyNot respecto de NotasPeq, y se juntan los dos.
	pos<-match(DatyNot[,"Carnet"],NotasPeq[,"Carnet"])
	NotasPeq<-NotasPeq[pos,]
	NotasPeq<-NotasPeq[,which(colnames(NotasPeq)!="Carnet")]
	Todo<-cbind(DatyNot,NotasPeq)
	#Todo<-SeparareImputar(Todo) #Se imputan los datos con NA
	pos2<-match(Todo[,"Carnet"],Datos.Personales[,"CARNET"])
	Nombre<-Datos.Personales[pos2,"ALUMNO"]
	Todo<-cbind(Nombre,Todo)
	Todo<-Todo[,colnames(Base)] #Se ordenan para poder hacer el rbind
	Todo<-rbind(Base,Todo)
	return(Todo)
}

