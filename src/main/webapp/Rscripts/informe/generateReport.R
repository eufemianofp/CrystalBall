generateReport <- function(currentYear, report_folder, report_title, graphs, subjects, years, graph_titles, comments){
	
	# loads the library for the reports
	library("Nozzle.R1");
  
  # create new report folder
  if (!dir.exists(report_folder)) {
    dir.create(report_folder)
    while (!dir.exists(report_folder)) {
      Sys.sleep(0.01)
    }
  }
  
	# creates the report title
	report <- newCustomReport(report_title);
	
	# semesters subjects, for comparison in graph="Prediccion vs Resultados"
	semester1 <- c("Matematicas", "Fisica", "Informatica", "Antropologia", "ECC");
	semester2 <- c("MatematicasII", "FisicaII", "Estadistica", "EconomiayEmpresa", "AntropologiaII", "ECCII");
	
	for(i in 1:length(graphs)){
		
		if(years[i] == "Todos los cursos") years[i] <- "todos";
		
		#==============================
		# BOXPLOT
		#==============================
		if(graphs[i] == "Boxplot"){
			section <- newSection(graph_titles[i]);
			
			print("Boxplot");
			
			# defines the figures file names and the data file name
			figureFileName <- paste("Image", i, ".png", sep="");
			figureHRFileName <- paste("ImageHR", i, ".png", sep="");
			tableDataFile <- paste("table_file", i, ".txt", sep="");
			
			# creates the figure in normal resolution and stores it in a folder
			png(file.path(report_folder, figureFileName), width=500, height=500);
			tableData <- AsigCurso(Todo, subjects[i], years[i]);
			dev.off();
			# creates the figure in high resolution and stores it in a folder
			png(file.path(report_folder, figureHRFileName), width=1200, height=1200);
			tableData <- AsigCurso(Todo, subjects[i], years[i]);
			dev.off();
			
			# generates the image and the table
			imagen <- newFigure(figureFileName, fileHighRes=figureHRFileName, comments[i]);
			write.table(tableData, file=file.path(report_folder, tableDataFile), quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE);
			tabla <- newTable(tableData, file=tableDataFile, significantDigits=3, comments[i]);
			
			# adds the image and the table to the section
			section <- addTo(section, imagen);
			section <- addTo(section, addTo(newSubSection("Tabla con los datos"), tabla));
			
			# adds section to report
			report <- addTo(report, section);
			
			
		#==============================
		# BOXPLOT SEGÚN TITULACIÓN
		#==============================
		} else if (graphs[i] == "BoxplotTit") {
			section <- newSection(graph_titles[i]);
			
			print("Boxplot segun titulacion");
			
			# defines the figures file names and the data file name
			figureFileName <- paste("Image", i, ".png", sep="");
			figureHRFileName <- paste("ImageHR", i, ".png", sep="");
			tableDataFile <- paste("table_file", i, ".txt", sep="");
			
			# creates the figure in normal resolution and stores it in a folder
			png(file.path(report_folder, figureFileName), width=500, height=500);
			tableData <- dibAsigTit(Todo, subjects[i], years[i]);
			dev.off();
			# creates the figure in high resolution and stores it in a folder
			png(file.path(report_folder, figureHRFileName), width=1200, height=1200);
			tableData <- dibAsigTit(Todo, subjects[i], years[i]);
			dev.off();
			
			# generates the image and the table
			imagen <- newFigure(figureFileName, fileHighRes=figureHRFileName, comments[i]);
			write.table(tableData, file=file.path(report_folder, tableDataFile), quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE);
			tabla <- newTable(tableData, file=tableDataFile, significantDigits=3, comments[i]);
			
			# adds the image and the table to the section
			section <- addTo(section, imagen);
			section <- addTo(section, addTo(newSubSection("Tabla con los datos"), tabla));
			
			# adds section to report
			report <- addTo(report, section);
			
			
		#==============================
		# PREDICCIÓN VS RESULTADOS
		#==============================
		} else if (graphs[i] == "Prediccion vs Resultados") {
			section <- newSection(graph_titles[i]);
			
			print("Prediccion vs Resultados");
			
			if (years[i] == currentYear) { # only if grades from semester 1 have been uploaded!
				# Prepares the data paths
				PrediccionesDir <- paste("Updates/", currentYear, "/", "Predicciones.RData", sep="");
				NotasDir <- paste("Updates/", currentYear, "/", "Parciales/Parciales.RData", sep="");
				
				# We need to load the RData first in a temporal environment
				tmpenv <- new.env();
				load(PrediccionesDir, envir=tmpenv);
				load(NotasDir, envir=tmpenv);
				
				# Now we assign the environment variables to our variables
				Predicciones <- tmpenv$Predicciones;
				Notas <- tmpenv$Parciales;
				
			} else {
				if (is.element(subject[i], semester1)) {
					Predicciones <- makePredictions(subjects[i], years[i], "PrimerSemestre");
					Notas <- Todo[which(as.vector(Todo$Curso) == year), 1:21];
				} else if (is.element(subject[i], semester2)){
					Predicciones <- makePredictions(subjects[i], years[i], "SegundoSemestre");
					Notas <- Todo[which(as.vector(Todo$Curso) == year), 1:28];
				} else {
					# unexpected value of subject
					next;
				}
			}
			
			# Gets the column of the selected subject in the data frame Predicciones, 1-dimensional array
			Predicciones <- takeSubject(Predicciones, subjects[i]);
			
			# defines the figures file names and the data file name
			figureFileName <- paste("Image", i, ".png", sep="");
			figureHRFileName <- paste("ImageHR", i, ".png", sep="");
			tableDataFile <- paste("table_file", i, ".txt", sep="");
			
			# creates the figure in normal resolution and stores it in a folder
			png(file.path(report_folder, figureFileName), width=500, height=500);
			tableData <- PlotGlm(Predicciones, Notas, subjects[i], subjects[i]);
			dev.off();
			# creates the figure in high resolution and stores it in a folder
			png(file.path(report_folder, figureHRFileName), width=1200, height=1200);
			tableData <- PlotGlm(Predicciones, Notas, subjects[i], subjects[i]);
			dev.off();
			
			# puts the marks and the predictions together in one data frame
			tableData <- cbind(tableData, Predicciones);
			
			# generates the image and the table
			imagen <- newFigure(figureFileName, fileHighRes=figureHRFileName, comments[i]);
			write.table(tableData, file=file.path(report_folder, tableDataFile), quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE);
			tabla <- newTable(tableData, file=tableDataFile, significantDigits=3, comments[i]);
			
			# adds the image and the table to the section
			section <- addTo(section, imagen);
			section <- addTo(section, addTo(newSubSection("Tabla con los datos"), tabla));
			
			# adds section to report
			report <- addTo(report, section);
			
			
		#==============================
		# TABLA CON CALIFICACIONES
		#==============================
		} else if (graphs[i] == "Tabla con calificaciones") {
			section <- newSection(graph_titles[i]);
			
			print("Tabla con calificaciones");
			
			#Here goes the table generation
			tableDataFile <- paste("table_file", i, ".txt", sep="");
			tableData <- TablaNotasAsignaturas(Todo, years[i], subjects[i]);
			
			write.table(tableData, file=file.path(report_folder, tableDataFile), quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE);
			tabla <- newTable(tableData, file=tableDataFile, significantDigits=3, comments[i]);
			
			section <- addTo(section, tabla);
			report <- addTo(report, section);
		}
	}
	
	# writes the report
	writeReport(report, filename=file.path(report_folder, report_title)); # w/o extension
}
