#=======================================#
#		 INTRODUCIR EXÁMENTES			#
#		    DE  ADMISIÓN				#
#=======================================#
#Definición:
	#Está función añade columnas a Datos.Personales dandonos información acerca del Examen de Admisión
	
#Parámetros de entrada:
	#Datos.Personales:un data frame que contiene todos los datos personales del alumno
	#path: directorio donde están guardados los excels con los exámenes de admisión

#Parámetros de salida:
	#Devuelve el mismo data.frame de la entrada, pero con dos columnas extras que indican la nota en los previos 
	#de Física y Mates
	
#Requisitos indispensables para que funcione:
	#En los archivos de los exámenes de admisión deben estar por lo menos las siguientes columnas: "CARNET", "NOTA_FIS", "NOTA_MATE", "NOTA_1º_BACHILLERATO"
	
#Ejemplo:
	#Datos.Personales<-IntroducirExAdmision(Datos.Personales,path)
	#path<-"C:/Users/Ángel Fuertes/Desktop/Universidad/Dropbox/CrystalBall/DatosExamenesAdmision/"


IntroducirExAdmision<-function(Datos.Personales,path)
{
	Files <- dir(path, pattern = "Ltdo.*csv$") #Se guardan en Files todos los archivos que hay en path
	Files <- paste(path,Files, sep="") #Ahora se guarda en Files la dirección entera para cada uno de esos archivos
	Admisiones <- data.frame();
	for (file in Files) {
    # print(paste("Leyendo datos de", file))
    Admision <- read.csv(file, fileEncoding = 'latin1') #Se lee cada archivo y se guarda en Admision
    Admision <- Admision[,c("CARNET", "NOTA_FIS", "NOTA_MATE", "NOTA_1º_BACHILLERATO")] #Se escogen los datos que interesan
    Admision[,"NOTA_FIS"]<-as.numeric(as.vector(Admision[,"NOTA_FIS"])) #Las notas tienen que ser numéricas
    Admision[,"NOTA_MATE"]<-as.numeric(as.vector(Admision[,"NOTA_MATE"])) #Las notas tienen que ser numéricas
    Admision[,"NOTA_1º_BACHILLERATO"]<-as.numeric(as.vector(Admision[,"NOTA_1º_BACHILLERATO"])) #Las notas tienen que ser numéricas
    Admisiones <- rbind(Admisiones, Admision) #Se junta todo en Admisiones para no perder esos datos en cada bucle.
	}
	
	filtro<-which(duplicated(Admisiones[,"CARNET"])==FALSE) #Si hay un alumno que aparece dos veces, solo se escoje una vez.
	Admisiones<-Admisiones[filtro,] 
	SoloAlumnosFinales<-which(is.na(Admisiones[,"CARNET"])==FALSE) #Se omiten aquellos que no están admitidos
	Admisiones<-Admisiones[SoloAlumnosFinales,]
	
	AlTot<-Datos.Personales[,"CARNET"] #Se guarda en AlTot los número de carnet de Datos.Personales
	pos<-match(AlTot,Admisiones[,"CARNET"]) #Indica en pos, la posición de cada Carnet de Admisiones respecto de AlTot.
	Admisiones<-Admisiones[pos,] #Se ordena
	Admisiones<-Admisiones[,c(2,3,4)] #Se omite el carnet
	Datos.Personales<-cbind(Datos.Personales,Admisiones) #Se juntan los dos
	
	return(Datos.Personales)
}

