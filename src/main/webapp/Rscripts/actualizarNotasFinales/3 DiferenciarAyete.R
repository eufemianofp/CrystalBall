#===============================================#
#		 DISTINGUIR A AQUELLOS ALUMNOS QUE 		#
#		 RESIDEN EN EL COLEGIO MAYOR AYETE		#
#===============================================#
#Definición:
	#Está función añade una columna a un data.frame dándonos información adicional sobre el Alojamiento de una persona (dice si vive en Ayete o no)
	
#Parámetros de entrada:
	#Datos.Personales:un data frame que contiene todos los datos personales del alumno. Debe de estar una columna que proporcione la 
	#Dirección del Domicilio durante el Curso.
	
#Parámetros de salida:
	#Devuelve el data.frame de la entrada, pero con una columna extra llamada Alojamiento, que  indica si alguien reside en C.M.Ayete
	
#Requisitos indispensables para que funcione:
	#-La columna que indica el domicilio durante el Curso debe llamarse: "DIR_DOM_CURSO"

#Ejemplo:
	#Datos.Personales<-DiferenciarAyete(Datos.Personales)



DiferenciarAyete<-function(Datos.Personales)
{
	a<-union(grep("AYETE", Datos.Personales[,"DIR_DOM_CURSO"]),grep("AIETE", Datos.Personales[,"DIR_DOM_CURSO"])) #Selección de las filas con alumnos
	b<-union(grep("Ayete", Datos.Personales[,"DIR_DOM_CURSO"]),grep("Aiete", Datos.Personales[,"DIR_DOM_CURSO"])) #que residan en Ayete.
	d<-union(a,b)

	deAyete <- intersect(
	            d,
      	      grep("25", Datos.Personales[,"DIR_DOM_CURSO"])) #Incluimos sólo los que residen en el colegio Mayor.
	Datos.Personales <- cbind(Datos.Personales, Alojamiento=factor("other", levels = c("other", "Ayete"))) #Añadimos una columna llamada Alojamiento con
	#dos levels: other y Ayete. E introducimos a todos other.
	Datos.Personales[deAyete,"Alojamiento"] <- "Ayete" #Sustituimos Ayete en Alojamiento para aquellos alumnos que habíamos seleccionado antes.
	return(Datos.Personales)
}

