#=======================================#
#			 				CARGAR DATOS							#
#		   	 			DESDE EXCEL								#
#=======================================#
#Definición:
	#Esta función convierte un archivo desde Excel a un data frame. Para ello
	#es necesario instalar el lenguaje de programación Perl.
	
#Parámetros de entrada:
	#filePath: direccion completa del archivo de Excel (debe terminar en .xlsx e ir entre comillas).
	#selectSheet: la Hoja de Excel que se va leer.
	#perlPath: dirección del archivo perl.exe (debe ir entre comillas).

#Parámetros de salida:
	#Data frame con la información del Excel.
	
#Librerías:
	#Es necesario tener instalada la librería 'gdata'.
	#Habrá que instalar: installXLSXsupport()  Esto sólo habrá que hacerlo una vez, nada más instalar gdata.
	
#Ejemplo:
	#PEQ.y.Parciales12<-cargarDatos("C:/Users/Ángel Fuertes/Desktop/Universidad/Dropbox/CrystalBall/arubio_Datos_Nuevos_a_Primero_20130520_sin_nombres.xlsx","C:/strawberry/perl/bin/perl.exe",3)
	
cargarDatos<-function(filePath,perlPath,selectSheet)
{
	suppressPackageStartupMessages(library('gdata'))
	MyDataFrame <- read.xls(filePath, perl=perlPath, sheet=selectSheet, verbose=FALSE, fileEncoding='latin1',as.is=TRUE) #Se lee el Excel
	return(MyDataFrame)
}
