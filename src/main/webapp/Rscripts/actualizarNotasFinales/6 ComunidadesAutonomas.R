#=======================================#
#		 AGRUPAR EN COMUNIDADES			#
#		   		AUTÓNOMAS				#
#=======================================#
#Definición:
	#Esta función añade una columna a un data.frame dándonos información acerca de las Comunidades Autonomas de cada alumno.
	
#Parámetros de entrada:
	#Prueba: es un data.frame que debe contener los Datos Personales del alumno.
	
#Parámetros de salida:
	#Devuelve el data.frame de la entrada, pero con una columna extra llamada Comunidades Autonomas.
	
#Requisitos indispensables para que funcione:
	#El data.frame de entrada debe tener por lo menos dos columnas llamadas "Carnet" y "Provincia"
	
#Ejemplo:
	#TodoConCAut<-ComunidadesAutonomas(Todo)
ComunidadesAutonomas<-function(Prueba)
{
a<-Prueba[,c("Carnet","Provincia")] #Se guarda en a, a cada alumno con su Provincia
colnames(a)<-c("Carnet","ComunidadAutonoma") #Se cambia el nombre de Provincia por ComunidadAutonoma
a[,"ComunidadAutonoma"]<-NA #Y se llena con NA

#Galicia
	Coruña<-which(Prueba[,"Provincia"]=="A Coruña") #Se mira para cada Comuniad Autónoma a ver si están las provincias de dicha C.Autónoma,
	Lugo<-which(Prueba[,"Provincia"]=="Lugo")  #y se sustituye en a cada una de esas filas por el nombre de su C.Autónoma
	Orense<-which(Prueba[,"Provincia"]=="Orense")
	Pontevedra<-which(Prueba[,"Provincia"]=="Pontevedra")

	Galicia<-union(union(Coruña,Lugo),union(Orense,Pontevedra))
	a[Galicia,"ComunidadAutonoma"]<-"Galicia"

#Asturias
	Asturias<-which(Prueba[,"Provincia"]=="Asturias")
	
	a[Asturias,"ComunidadAutonoma"]<-"Asturias"

#Cantabria
	Cantabria<-which(Prueba[,"Provincia"]=="Cantabria")

	a[Cantabria,"ComunidadAutonoma"]<-"Cantabria"

#País Vasco
	Alava<-which(Prueba[,"Provincia"]=="Álava")
	Guipuzcoa<-which(Prueba[,"Provincia"]=="Guipúzcoa")
	Vizcaya<-which(Prueba[,"Provincia"]=="Vizcaya")

	PaisVasco<-union(union(Alava,Guipuzcoa),Vizcaya)
	a[PaisVasco,"ComunidadAutonoma"]<-"PaisVasco"

#Navarra
	Navarra<-which(Prueba[,"Provincia"]=="Navarra")

	a[Navarra,"ComunidadAutonoma"]<-"Navarra"

#LaRioja
	LaRioja<-which(Prueba[,"Provincia"]=="La Rioja")

	a[LaRioja,"ComunidadAutonoma"]<-"La Rioja"

#Aragon
	Huesca<-which(Prueba[,"Provincia"]=="Huesca")
	Zaragoza<-which(Prueba[,"Provincia"]=="Zaragoza")
	Teruel<-which(Prueba[,"Provincia"]=="Teruel")

	Aragon<-union(union(Huesca,Zaragoza),Teruel)
	a[Aragon,"ComunidadAutonoma"]<-"Aragon"

#Cataluña
	Barcelona<-which(Prueba[,"Provincia"]=="Barcelona")
	Tarragona<-which(Prueba[,"Provincia"]=="Tarragona")
	Girona<-which(Prueba[,"Provincia"]=="Girona")
	Lleida<-which(Prueba[,"Provincia"]=="Lleida")

	Cataluña<-union(union(Barcelona,Tarragona),union(Girona,Lleida))
	a[Cataluña,"ComunidadAutonoma"]<-"Cataluña"

#Baleares
	Baleares<-which(Prueba[,"Provincia"]=="Illes Balears")

	a[Baleares,"ComunidadAutonoma"]<-"Baleares"

#Canarias
	Tenerife<-which(Prueba[,"Provincia"]=="Santa Cruz De Tenerife")
	LasPalmas<-which(Prueba[,"Provincia"]=="Las Palmas")

	Canarias<-union(Tenerife,LasPalmas)
	a[Canarias,"ComunidadAutonoma"]<-"Canarias"

#ComunidadValenciana
	Castellon<-which(Prueba[,"Provincia"]=="Castellón")
	Valencia<-which(Prueba[,"Provincia"]=="Valencia")
	Alicante<-which(Prueba[,"Provincia"]=="Alicante")

	ComunidadValenciana<-union(union(Castellon,Valencia),Alicante)
	a[ComunidadValenciana,"ComunidadAutonoma"]<-"ComunidadValenciana"

#Murcia
	Murcia<-which(Prueba[,"Provincia"]=="Murcia")

	a[Murcia,"ComunidadAutonoma"]<-"Murcia"

#Andalucia
	Almeria<-which(Prueba[,"Provincia"]=="Almería")
	Granada<-which(Prueba[,"Provincia"]=="Granada")
	Cordoba<-which(Prueba[,"Provincia"]=="Córdoba")
	Jaen<-which(Prueba[,"Provincia"]=="Jaén")
	Sevilla<-which(Prueba[,"Provincia"]=="Sevilla")
	Malaga<-which(Prueba[,"Provincia"]=="Málaga")
	Cadiz<-which(Prueba[,"Provincia"]=="Cádiz")
	Huelva<-which(Prueba[,"Provincia"]=="Huelva")


	Andalucia<-union(union(Almeria,Granada),union(Cordoba,Jaen))
	Andalucia2<-union(union(Sevilla,Malaga),union(Cadiz,Huelva))
	Andalucia<-union(Andalucia,Andalucia2)
	a[Andalucia,"ComunidadAutonoma"]<-"Andalucia"

#Castilla y León
	Burgos<-which(Prueba[,"Provincia"]=="Burgos")
	Leon<-which(Prueba[,"Provincia"]=="León")
	Palencia<-which(Prueba[,"Provincia"]=="Palencia")
	Salamanca<-which(Prueba[,"Provincia"]=="Salamanca")
	Soria<-which(Prueba[,"Provincia"]=="Soria")
	Valladolid<-which(Prueba[,"Provincia"]=="Valladolid")
	Zamora<-which(Prueba[,"Provincia"]=="Zamora")

	CastillayLeon<-union(union(Burgos,Leon),union(Palencia,Salamanca))
	CastillayLeon<-union(union(CastillayLeon,Soria),union(Valladolid,Zamora))
	a[CastillayLeon,"ComunidadAutonoma"]<-"CastillayLeon"

#Madrid
	Madrid<-which(Prueba[,"Provincia"]=="Madrid")

	a[Madrid,"ComunidadAutonoma"]<-"Madrid"

#CastillaLaMancha
	Toledo<-which(Prueba[,"Provincia"]=="Toledo")
	CiudadReal<-which(Prueba[,"Provincia"]=="Ciudad Real")
	Cuenca<-which(Prueba[,"Provincia"]=="Cuenca")
	Guadalajara<-which(Prueba[,"Provincia"]=="Guadalajara")
	Albacete<-which(Prueba[,"Provincia"]=="Albacete")

	CastillaLaMancha<-union(union(Toledo,CiudadReal),union(Cuenca,Guadalajara))
	CastillaLaMancha<-union(CastillaLaMancha,Albacete)
	a[CastillaLaMancha,"ComunidadAutonoma"]<-"CastillaLaMancha"

#Extremadura
	Caceres<-which(Prueba[,"Provincia"]=="Cáceres")
	Badajoz<-which(Prueba[,"Provincia"]=="Badajoz")

	Extremadura<-union(Caceres,Badajoz)
	a[Extremadura,"ComunidadAutonoma"]<-"Extremadura"

#Extranjeros
	a[which(is.na(a[,"ComunidadAutonoma"])==TRUE),"ComunidadAutonoma"]<-"Extranjeros" #Para todos los que falten, se les sustituye por extranjeros
	a[,"ComunidadAutonoma"]<-as.factor(a[,"ComunidadAutonoma"])

a<-merge(Prueba,a,by="Carnet") #Se añade las Communidades Autónomas
return(a)
}





