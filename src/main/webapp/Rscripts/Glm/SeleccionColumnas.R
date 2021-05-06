
#===========================================#
#		 SELECCIONAR COLUMNAS CON			#
#			 DATOS SUFICIENTES				#
#===========================================#

#Definición:
#	Esta función seleccióna aquellas columnas de un data.frame en las que el número de NA no supera el 60%.

#Parámetros de entrada:
	#Un data.frame a evaluar
	
#Parámetros de salida:
	#El mismo data.frame a la entrada pero solamente con las columnas que cumplen que el número de NA no superan el 60% de los datos de dicha columna.
		
#Ejemplo:
	#Todo<-SeleccionColumnas(Todo)



SeleccionColumnas<-function(Primero)
{
	a=0
	for (i in 1:ncol(Primero)) #Se recorre cada columna de Primero
	{
		if(sum(is.na(Primero[,i] ))<=0.6*nrow(Primero)) #Se incluyen sólo aquellos en los que el número de NA no supera el 60%
		{	
			if(a==0) #Cuando se hace por primera vez
			{
				nuevo<-Primero[,i] #Se copia la columna en nuevo
				nuevo<-as.data.frame(nuevo) #clase data.frame
				a=1 #Se cambia el valor de a para que ya no vuelva a entrar en esta condición.
				posiciones<-i #se guerda en posiciones la posición de la columna introducida.
			}
			else #Cuando no se hace por primera vez
			{
				nuevo<-cbind(nuevo,Primero[,i]) #se juntan los datos en nuevo
				posiciones<-rbind(posiciones,i) #se guerdan las posiciones en posiciones
			}
		}

	}
	colnames(nuevo)<-colnames(Primero)[posiciones] #Los nombres de las columnas deben ser iguales.
	return(nuevo)
}