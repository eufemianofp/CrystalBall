#=======================================#
#		 NOTAS OBTENIDAS EN LOS			#
#		   PEQ Y PARCIALES				#
#=======================================#
#Definición:
	#Esta función nos devuelve los datos de los PEQ y los Parciales
	
#Parámetros de entrada:
	#PEQ.y.Parciales: un data frame que contiene por columnas: números de carnet, nombre de los PEQ, la nota, sobre cuánto es esa nota y el Curso.
	#Curso: el curso del que se escogen  los datos (se hace para descartar a aquellos alumnos que están repitiendo la asignatura)
	
#Parámetros de salida:
	#Un data.frame que contiene los distintos PEQ por columnas y su nota sobre 10 para cada alumno(filas).
	
#Requisitos indispensables para que funcione:
	#-En las columnas de PEQ.y.Parciales deben estar por lo menos: "CARNET","NOTA","SOBRE","CURSO" y "PEQ"
	#-En la columna PEQ, los levels deben de ser los siguientes (escritos tal y como se indica a continuación):"Peq1Calculo","Peq1Algebra",
	#"ParcialAlgebra","ParcialCalculo","Peq2Calculo","FisicaElectricidad","FisicaOndas","PeqInformatica","PeqMatesII","PeqEstadistica"
	
#Librerías:
	#Es necesaria la librería reshape2 para la función dcast.
	
#Ejemplo:
	#NotasPeq<-notaspeq(PEQ.y.Parciales,Curso)


notaspeq <- function(PEQ.y.Parciales, Curso)
{
  suppressPackageStartupMessages(library('reshape2'))
  
  PEQ.y.Parciales <-
    PEQ.y.Parciales[which(PEQ.y.Parciales[, "CURSO"] == Curso),] #Se escogen los datos del curso indicado

  PEQ.y.Parciales[, "NOTA"] <-
    gsub(",", "\\.", PEQ.y.Parciales[, "NOTA"])  #Sustitución de las comas por puntos
  PEQ.y.Parciales[, "SOBRE"] <-
    gsub(",", "\\.", PEQ.y.Parciales[, "SOBRE"]) #Sustitución de las comas por puntos
  
  PEQ.y.Parciales[which(PEQ.y.Parciales$NOTA=="NP"), "NOTA"] <- "0"
  
  PEQ.y.Parciales[, "NOTA"] <-
    as.numeric(as.vector(PEQ.y.Parciales[, "NOTA"])) #Clase numeric
  PEQ.y.Parciales[, "SOBRE"] <-
    as.numeric(as.vector(PEQ.y.Parciales[, "SOBRE"])) #Clase numeric

  PEQ.y.Parciales[, "NOTA"] <-
    PEQ.y.Parciales[, "NOTA"] * 10 / PEQ.y.Parciales[, "SOBRE"] #Se establece que las notas estén entre 0 y 10

  peqfin <-
    dcast(PEQ.y.Parciales,
          CARNET ~ PEQ,
          value.var = "NOTA",
          fun.aggregate = mean) #Se dejan los nombres de los PEQ por columnas en función del alumno

  peqfin <-
    peqfin[, c(
      "CARNET",
      "Peq1Calculo",
      "Peq1Algebra",
      "ParcialAlgebra",
      "ParcialCalculo",
      "Peq2Calculo",
      "FisicaElectricidad",
      "FisicaOndas",
      "PeqInformatica",
      "PeqMatesII",
      "PeqEstadistica"
    )]
  #Se escogen las columnas que interesan
  return(peqfin)
}
