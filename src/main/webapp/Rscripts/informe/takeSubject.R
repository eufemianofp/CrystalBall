takeSubject <- function(Predicciones, subject){
	
	if(subject == "Matematicas"){
		# this separation is made for possible future tries
		predicciones <- Predicciones$MatEsp;
		return(Predicciones$MatEsp);
	}else if(subject == "Fisica"){
		predicciones <- Predicciones$FisEsp;
		return(predicciones);
	}else if(subject == "Informatica"){
		predicciones <- Predicciones$InfEsp;
		return(predicciones);
	}else if(subject == "Antropologia"){
		predicciones <- Predicciones$AntEsp;
		return(predicciones);
	}else if(subject == "ECC"){
		predicciones <- Predicciones$ECCEsp;
		return(predicciones);
	}else if(subject == "MatematicasII"){
		predicciones <- Predicciones$MatIIEsp;
		return(predicciones);
	}else if(subject == "FisicaII"){
		predicciones <- Predicciones$FisIIEsp;
		return(predicciones);
	}else if(subject == "Estadistica"){
		predicciones <- Predicciones$EstEsp;
		return(predicciones);
	}else if(subject == "EconomiayEmpresa"){
		predicciones <- Predicciones$EcoEsp;
		return(predicciones);
	}else if(subject == "AntropologiaII"){
		predicciones <- Predicciones$AntIIEsp;
		return(predicciones);
	}else if(subject == "ECCII"){
		predicciones <- Predicciones$ECCIIEsp;
		return(predicciones);
	}
}