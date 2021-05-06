makePredictions <- function(subject, year, semester){
	
	if(semester == "PrimerSemestre"){
		ParcialesSemester1 <- Todo[which(as.vector(Todo$Curso) == year),1:21];
		semester <- GenerarTablaPredicciones(Todo, ParcialesSemester1, 0.8, 'PrimerSemestre')
	}else if(semester == "SegundoSemestre"){
		ParcialesSemester2 <- Todo[which(as.vector(Todo$Curso) == year),1:28]
		semester <- GenerarTablaPredicciones(Todo, ParcialesSemester2, 0.8, 'SegundoSemestre')
	}else{
		#unexpected value of subject
	}
	
	semester <- as.data.frame(semester);
	return(semester);
}