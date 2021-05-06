
#===========================================#
#			BASE PARA GENERAR 				#
#			 GLMNET GENÉRICO				#
#===========================================#

#Definición:
#	Esta función devuelve el data.frame correspondiente a los alumnos de años anteriores, de la manera adecuada para poder hacer posteriormente el cv.glmnet y la predicción.

#Parámetros de entrada:
	#Base: un data.frame que contiene toda la información necesaria sobre los alumnos de años anteriores.(Es sobre la que se va a basar el cv.glmnet)
	#Primero: data.frame que contiene la información obtenida en un determinado tiempo sobre los alumnos de Primero.
	#asignatura: asignatura a predecir
	#a: TRUE si hay NA en la Base
	#	FALSE si la Base está imputada.
	
#Parámetros de salida:
	#Devuelve el data.frame con el que se quiere predecir, pero con las mismas columnas que tendrá también el data.frame con los alumnosa a
	#predecir, para que se pueda realizar la predicción.
	
#Funciones necesarias:
	#SeleccionColumnas, SeleccionSinNa, SeparareImputar, SepararFactores
	
#Requisitos indispensables para que funcione:
	#-El nombre de la asignatura debe corresponderse con las asignaturas disponibles.
	#-Deben cumplirse todos los requisitos de las funciones necesarias.
		
#Ejemplo:
	#BaseGen<-BaseGenerico(Base,FinalesNoviembre,asignatura,TRUE)

BaseGenerico<-function(Base,Primero,asignatura,a)
{
	Primero<-SeleccionColumnas(Primero) #Se seleccionan únicamente aquellas columnas que no tienen más del 60% de NA
	Primero<-Primero[,which(colnames(Primero)!="Carnet")] #Se omite la columna del Carnet
	Base2<-Base[,colnames(Primero)] #Se escoge las columnas de la base que están en Primero
	if (a==TRUE) #Si hay NA, hay que quitárselos
	{
		Basejunta<-cbind(Base2,Base[,asignatura]) #Se introduce la asignatura
		Basejunta<-SeleccionSinNA(Basejunta) #Se omiten aquellas filas que tengan algún NA
		colnames(Basejunta)[which(colnames(Basejunta) %in% colnames(Base2)==FALSE)]<-asignatura #Se introduce correctamente el nombre de la asignatura
		Base2<-Basejunta[,which(colnames(Basejunta) !=asignatura)] #Se guarda en Base2 todo menos los datos de la asignatura
		Base<-Basejunta #En Base se guarda todo, inclusive la asignatura.
	}	
	junto<-rbind(Base2,Primero) #Se juntan Base2 con Primero (para que al hacer el model.matrix tengan el mismo nombre las columnas)
	junto<-SeparareImputar(junto) #Se imputan aquellos datos que tengan NA (como antes o bien se han quitado los NA o bien la Base estaba imputada, se están imputando los datos de Primero)
	junto<-SepararFactores(junto) #Se separan los levels de los factores por columnas
	BaseCorr<-junto[1:nrow(Base2),] #Se guardan los valores correspondientes a la Base
	BaseConAsign<-cbind(BaseCorr,Base[,asignatura]) #Se introduce la asignatura
	colnames(BaseConAsign)[which(colnames(BaseConAsign) %in% colnames(BaseCorr)==FALSE)]<-asignatura #Se introduce correctamente el nombre de la asignatura
	return(BaseConAsign)
}