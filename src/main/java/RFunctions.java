import java.io.File;

import org.apache.commons.lang3.ArrayUtils;
import org.json.JSONArray;
import org.rosuda.REngine.Rserve.RConnection;


public class RFunctions {

	public static int count = 0;
	// private static String currentYear = AuxiliaryFunctions.getCurrentYear();

	/*
	 * =============================================================================
	 *  All these methods are SYNCHRONIZED. This is to avoid two threads from
	 *  using the RConnection at the same time, since this would crash the R
	 * server (Rserve) in Windows.
	 * =============================================================================
	 */

	public synchronized static String[] alumnos(RConnection c, String requested_year) {

		System.out.println("	-->Calling the RFunction: alumnos");

		String[] alumnos = null;
		String current_year = AuxiliaryFunctions.getCurrentYear();

		try {
			if (requested_year.equals(current_year)) {
				String input = "as.character(Parciales$Carnet[which(Parciales$Curso == '" + requested_year + "')])";
				System.out.println("	" + input);
				alumnos = c.eval(input).asStrings();
			} else {
				String input = "as.character(Todo$Carnet[which(Todo$Curso == '" + requested_year + "')])";
				System.out.println("	" + input);
				alumnos = c.eval(input).asStrings();
			}
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
		}
		return alumnos;
	}

	
	public synchronized static int[] buscar(RConnection c, String carnet) {

		System.out.println("	-->Calling the RFunction: buscar");

		int[] carnets = null;

		try {
			String input = "Todo[which(startsWith(as.character(Todo[,'Carnet']),'" + carnet + "')==T),'Carnet']";
			System.out.println("	" + input);
			int[] carnetsAntiguos = c.eval(input).asIntegers();

			input = "Parciales[which(startsWith(as.character(Parciales[,'Carnet']),'" + carnet + "')==T),'Carnet']";
			System.out.println("	" + input);
			int[] carnetsNuevos = c.eval(input).asIntegers();

			// Concatenates the old students with this year's students
			carnets = ArrayUtils.addAll(carnetsAntiguos, carnetsNuevos);
		} catch (Exception e) {
			System.out.println("	The number written does not correspond to any student");
		}
		return carnets;
	}

	
	public synchronized static String[] cargarCursos(RConnection c) {

		System.out.println("	-->Calling the RFunction: cargarCursos");

		String[] cursos = null;

		try {
			String input = "as.character(unique(Todo$Curso))";
			System.out.println("	" + input);
			cursos = c.eval(input).asStrings();
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
		}
		return cursos;
	}
	
	
	public synchronized static boolean create_parciales_new_year(RConnection c, String next_year) {

		System.out.println("	-->Calling the RFunction: create_parciales_new_year");

		boolean success = false;

		try {
			// Delete all rows in Parciales but keep schema
			String input = "Parciales <- Parciales[NULL, ]";
			System.out.println("	" + input);
			c.voidEval(input);

			String next_year_folder_path = AuxiliaryFunctions.getWD() + "/Updates/" + next_year + "/Parciales";
			input = "save(Parciales, file='" + next_year_folder_path + "/Parciales.RData')";
			System.out.println("	" + input);
			c.voidEval(input);

			success = true;
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
			e.printStackTrace();
		}
		return success;
	}

	
	public synchronized static String[] datosAlumno(RConnection c, String carnet, String currentYear, String studentYear) {

		System.out.println("	-->Calling the RFunction: datosAlumno");

		String[] all_columns = null;

		String df = null;
		if (studentYear.equals(currentYear)) {
			df = "Parciales";
		} else {
			df = "Todo";
		}
		// We have to convert the factor fields into character fields, in order to be
		// read correctly by c.eval
		String input1 = "i <- sapply(" + df + ", is.factor)";
		String input2 = df + "_no_factor <- " + df;
		String input3 = df + "_no_factor[i] <- lapply(" + df + "[i], as.character)";
		String input4 = "as.character(" + df + "_no_factor[which(" + df + "[, 'Carnet']==" + carnet + "), c(1, 3:10)])";
		String input5 = "as.character(" + df + "_no_factor[which(" + df + "[, 'Carnet']==" + carnet + "), c(2, 11:ncol(" + df + "))])";
		
		try {
			c.voidEval(input1);
			c.voidEval(input2);
			c.voidEval(input3);
			String[] descriptive_columns = c.eval(input4).asStrings();
			String[] numeric_columns = c.eval(input5).asStrings();

			all_columns = ArrayUtils.addAll(descriptive_columns, numeric_columns);

		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
			e.printStackTrace();
		}

		return all_columns;
	}

	
	public synchronized static String generateReport(RConnection c, String report_title, JSONArray graphs,
			JSONArray subjects, JSONArray years, JSONArray titles, JSONArray comments, String folderName) {

		System.out.println("	-->Calling the RFunction: generateReport");
		
		Rserve.loadData(c);

		String reportPath = null;
		String current_year = AuxiliaryFunctions.getCurrentYear();

		try {
			// Loads functions needed to plot the graphs for the report
			String input = "source('Rscripts/informe/AsigCurso.R')";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "source('Rscripts/informe/dibAsigTit.R')";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "source('Rscripts/informe/PlotGlm.R', encoding='UTF-8')";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "source('Rscripts/informe/TablaNotasAsignaturas.R')";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "source('Rscripts/informe/makePredictions.R')";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "source('Rscripts/informe/takeSubject.R')";
			System.out.println("	" + input);
			c.voidEval(input);

			// Loads the function that generates the report
			input = "source('Rscripts/informe/generateReport.R', encoding='UTF-8')";
			System.out.println("	" + input);
			c.voidEval(input);

			/*
			 * NOW WE HAVE TO CONVERT THE JSONArrays IN R ARRAYS
			 */
			int length = graphs.length();

			// For the graphs we have to change the accents
			input = "graphs <- c('";
			for (int i = 0; i < length - 1; i++) {
				if (graphs.getString(i).equals("Boxplot según titulación"))
					input += "BoxplotTit', '";
				else if (graphs.getString(i).equals("Predicción vs Resultados"))
					input += "Prediccion vs Resultados', '";
				else
					input += graphs.getString(i) + "', '";
			}
			if (graphs.getString(length - 1).equals("Boxplot según titulación"))
				input += "BoxplotTit')";
			else if (graphs.getString(length - 1).equals("Predicción vs Resultados"))
				input += "Prediccion vs Resultados')";
			else
				input += graphs.getString(length - 1) + "')";
			System.out.println("	" + input);
			c.voidEval(input);

			// And for the subjects too, but now we will use an auxiliary function
			input = "subjects <- c('";
			String subject = null;
			for (int i = 0; i < length - 1; i++) {
				subject = subjects.getString(i);
				input += AuxiliaryFunctions.quitarTildesAsignatura(subject) + "', '";
			}
			subject = subjects.getString(length - 1);
			input += AuxiliaryFunctions.quitarTildesAsignatura(subject) + "')";
			System.out.println("	" + input);
			c.voidEval(input);

			input = "years <- c('";
			for (int i = 0; i < length - 1; i++)
				input += years.getString(i) + "', '";
			input += years.getString(length - 1) + "')";
			System.out.println("	" + input);
			c.voidEval(input);

			input = "graph_titles <- c('";
			for (int i = 0; i < length - 1; i++)
				input += titles.getString(i) + "', '";
			input += titles.getString(length - 1) + "')";
			System.out.println("	" + input);
			c.voidEval(input);

			input = "comments <- c('";
			for (int i = 0; i < length - 1; i++)
				input += comments.getString(i) + "', '";
			input += comments.getString(length - 1) + "')";
			System.out.println("	" + input);
			c.voidEval(input);

			// Executes the function that generates the report
			input = "generateReport('" + current_year + "', 'Reports/" + folderName + "', '" + report_title
					+ "', graphs, subjects, years, graph_titles, comments)";
			System.out.println("	" + input);
			c.voidEval(input);

			Rserve.loadData(c);

			reportPath = "Reports/" + folderName + "/" + report_title + ".html";
		} catch (Exception e) {
			System.out.println("	An error ocurred during the generation of the report.");
			System.out.println();
			e.printStackTrace();
		}
		return reportPath;
	}

	
	public synchronized static String[] getParcialesColnames(RConnection c) {

		System.out.println("	-->Calling the RFunction: getParcialesColnames");

		String[] parcialesColnames = null;

		try {
			String input = "colnames(Parciales[11:ncol(Parciales)])";
			System.out.println("	" + input);
			parcialesColnames = c.eval(input).asStrings();
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
		}
		return parcialesColnames;
	}

	public synchronized static String[] getPredicciones(RConnection c, String carnet) {

		System.out.println("	-->Calling the RFunction: getPredicciones");

		String[] predicciones = null;
		String input = "";
		String student_year = getStudentYear(c, carnet);
		String current_year = AuxiliaryFunctions.getCurrentYear();
		
		try {
			if (student_year.equals(current_year)) {
				System.out.println("	Current year");

				input = "as.character(Predicciones[which(Predicciones$Carnet==" + carnet + "),])";
				System.out.println("	" + input);

				// An RserveException is thrown when trying to retrieve a list from Rserve
				// RList l = c.eval(input).asList();
				// Hence we wrap the output inside the as.character() function

				predicciones = c.eval(input).asStrings();

			} else {
				System.out.println("	Previous year");

				String input1 = "load('" + AuxiliaryFunctions.getWD() + "Updates/" + student_year + "/Predicciones.RData')";
				String input2 = "oldPredicciones <- Predicciones";
				String input3 = "prediccionesAlumno <- as.character(oldPredicciones[which(oldPredicciones$Carnet==" + carnet + "),])";

				System.out.println("	" + input1);
				System.out.println("	" + input2);
				System.out.println("	" + input3);

				c.voidEval(input1);
				c.voidEval(input2);
				// c.voidEval(input3);

				predicciones = c.eval(input3).asStrings();

				// Set 'Predicciones' variable in the R session with current year's 'Predicciones' only if they already exist
				String predicciones_current_year_path = AuxiliaryFunctions.getWD() + "Updates/" + current_year + "/Predicciones.RData";
				File predicciones_current_year = new File(predicciones_current_year_path);
				
				if (predicciones_current_year.exists()) {
					String input4 = "load('" + predicciones_current_year_path + ")";
					System.out.println("	" + input4);
					c.voidEval(input4);
				}
			}
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
			e.printStackTrace();
		}
		
		return predicciones;
	}

	
	public synchronized static String getStudentYear(RConnection c, String carnet) {

		System.out.println("	-->Calling the RFunction: getStudentYear");

		// String[] years = null;
		String year = null;
		String input = "";
		try {
			// Let's see if this student is from the current year
			input = "as.character(Parciales[which(Parciales$Carnet==" + carnet + "), 'Curso'])";
			System.out.println("	" + input);
			year = c.eval(input).asStrings()[0];
		} catch (Exception e) {
			System.out.println("	Student is from a previous academic year");
			try {
				// If this executes is because the student is from past years
				input = "as.character(Todo[which(Todo$Carnet==" + carnet + "), 'Curso'])";
				System.out.println("	" + input);
				year = c.eval(input).asStrings()[0];
			} catch (Exception ex) {
				System.out.println("	An error ocurred during the request to Rserve");
				System.out.println();
			}
		}
		// System.out.println("	Student year: " + year);
		return year;
	}

	
	public synchronized static boolean isSemester1Uploaded(RConnection c) {

		System.out.println("	-->Calling the RFunction: is1SemesterUploaded");

		boolean uploaded = false;

		try {
			String input = "length(which(is.na(Parciales$Matematicas))) != nrow(Parciales)";
			System.out.println("	" + input);
			String response = c.eval(input).asString();
			if (response.equals("TRUE"))
				uploaded = true;
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
		}
		return uploaded;
	}

	
	public synchronized static boolean makePredictions(RConnection c) {

		System.out.println("	-->Calling the RFunction: makePredictions");

		boolean success = false;
		String current_year = AuxiliaryFunctions.getCurrentYear();

		try {
			// Loads the functions needed to make the predictions
			String input = "source('Rscripts/loadRscriptsPredicciones.R')";
			System.out.println("	" + input);
			c.voidEval(input);
			// Loads the function that makes the prediction
			input = "source('Rscripts/GenerarTablaPredicciones.R')";
			System.out.println("	" + input);
			c.voidEval(input);

			// First semester, Parciales excludes rows 21:28 (Notas finales 1 semestre +
			// peqs 2 semestre)
			input = "semester1 <- suppressMessages(GenerarTablaPredicciones(Todo, Parciales[,1:21], 0.8, 'PrimerSemestre'))";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "semester1 <- as.data.frame(semester1)";
			System.out.println("	" + input);
			c.voidEval(input);

			// Second semester
			input = "semester2 <- GenerarTablaPredicciones(Todo, Parciales, 0.8, 'SegundoSemestre')";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "semester2 <- as.data.frame(semester2)";
			System.out.println("	" + input);
			c.voidEval(input);

			// Removes the "Carnet" field, 1 semester already has it since they're going to
			// merge
			input = "semester2$Carnet <- NULL";
			System.out.println("	" + input);
			c.voidEval(input);

			// Merges both semesters
			input = "Predicciones <- cbind(semester1, semester2)";
			System.out.println("	" + input);
			c.voidEval(input);

			input = "save(Predicciones, file='Updates/" + current_year + "/Predicciones.RData')";
			System.out.println("	" + input);
			c.voidEval(input);

			success = true;
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
		}
		return success;
	}


	public synchronized static String[] state(RConnection c) {

		System.out.println("	-->Calling the RFunction: state");

		String[] uploadedGrades = null;

		try {
			// Returns the colnames of those columns whose values are not NA's
			String input = "colnames(Parciales[,colSums(is.na(Parciales)) != nrow(Parciales)])";
			System.out.println("	" + input);
			String[] fields = c.eval(input).asStrings();

			if (fields.length == 0)
				return uploadedGrades;

			uploadedGrades = new String[fields.length - 10];
			for (int i = 10; i < fields.length; i++) { // The first 10 fields are not grades, just information
				uploadedGrades[i - 10] = fields[i];
			}
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve. Data frame 'Parciales' not found."
					+ " This means there haven't been uploaded any grades yet.");
			System.out.println();
		}
		return uploadedGrades;
	}

	
	public synchronized static boolean updateFinales(RConnection c, String excelPath, String csvPath, String current_year, String next_year) {

		System.out.println("	-->Calling the RFunction: updateFinales");

		boolean updated = false;

		try {
			String perlPath = AuxiliaryFunctions.getPerlPath();

			String input = "source('Rscripts/loadRscriptsNotasFinales.R')";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "source('Rscripts/actualizarNotasFinales.R')";
			System.out.println("	" + input);
			c.voidEval(input);

			input = "Datos.Personales <- cargarDatos('" + excelPath + "', '" + perlPath + "', 'Datos Personales')";
			System.out.println("	" + input);
			c.voidEval(input);
			System.out.println("	Datos Personales: cargados");

			input = "Calificaciones <- cargarDatos('" + excelPath + "', '" + perlPath + "', 'Calificaciones')";
			System.out.println("	" + input);
			c.voidEval(input);
			System.out.println("	Calificaciones: cargadas");

			input = "PEQ.y.Parciales <- cargarDatos('" + excelPath + "', '" + perlPath + "', 'PEQ y Parciales')";
			System.out.println("	" + input);
			c.voidEval(input);
			System.out.println("	Peq y Parciales: cargados");

			input = "Todo <- ActualizarDatos(Datos.Personales, Calificaciones, PEQ.y.Parciales, '" + csvPath + "/', '" + current_year + "', Todo)";
			System.out.println("	" + input);
			c.voidEval(input);
			System.out.println("	Datos: actualizados");

			input = "save(Todo, file='Data/AllData.RData')";
			System.out.println("	" + input);
			c.voidEval(input);
			System.out.println("	Datos: guardados");

		} catch (Exception e) {
			System.out.println("	An Rserve error ocurred during the update of data from year " + current_year);
			System.out.println();
		}
		
		try {
			
			updated = create_parciales_new_year(c, next_year);
			
			String load_parciales = "load('" + AuxiliaryFunctions.getWD() + "Updates/" + next_year + "/Parciales/Parciales.RData')";
			System.out.println("	" + load_parciales);
			c.voidEval(load_parciales);
			
		} catch (Exception e) {
			System.out.println("	An Rserve error ocurred while creating new Parciales dataframe for year " + next_year);
			System.out.println();
		}
		
		return updated;
	}

	
	public synchronized static boolean updateParciales(RConnection c, String filePath) {

		System.out.println("	-->Calling the RFunction: updateParciales");

		boolean updated = false;
		String current_year = AuxiliaryFunctions.getCurrentYear();

		try {
			String Rwd = c.eval("getwd()").asString();
			System.out.println("	R working directory: " + Rwd);
			
			String input = "source('Rscripts/cargarDatos.R')";
			System.out.println("	" + input);
			c.voidEval(input);
			
			input = "Parciales <- cargarDatos('" + filePath + "', '" + AuxiliaryFunctions.getPerlPath() + "', 'Parciales')";
			System.out.println("	" + input);
			c.voidEval(input);

			// Substitutes the names of the columns with the names of the data frame "Todo"
			input = "colnames(Parciales)[1:(ncol(Parciales)-3)] <- colnames(Todo[1:(ncol(Parciales)-3)])";
			System.out.println("	" + input);
			c.voidEval(input);

			// Deletes the columns that are used just for limiting the names of the column
			// "Plan", "Sexo" and "Alojamiento"
			input = "Parciales$ListaGrados <- NULL";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$ListaSexos <- NULL";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$ListaAlojamiento <- NULL";
			System.out.println("	" + input);
			c.voidEval(input);

			// Due to these lists, there are additional empty rows if the number of students
			// inserted is less
			// than the length of the largest of these two lists. So now we remove the empty
			// rows.
			input = "Parciales[Parciales==''] <- NA";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales <- Parciales[rowSums(!is.na(Parciales))>0, ]";
			System.out.println("	" + input);
			c.voidEval(input);

			// We change the values of the column "Plan", so they later have all the same
			// name in the data frame "Todo"
			input = "Parciales$Plan[grep('Tecnolog', Parciales$Plan)] <- 'Gr.Ing.Tecn.Ind-09'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[grep('Org', Parciales$Plan)] <- 'Gr.Ing.Org.Ind-09'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[grep('Mec', Parciales$Plan)] <- 'Gr.Ing.Mecánica-09'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[grep('Bio', Parciales$Plan)] <- 'Gr.Ing.Bioméd-09'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[grep('Dis', Parciales$Plan)] <- 'Gr.Ing.Dis.Ind.-09'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[grep('Telecomunicac', Parciales$Plan)] <- 'Gr.Ing.Sist.Tel-09'";
			System.out.println("	" + input);
			c.voidEval(input);

			// This degree names are troubling when looking for a substring like "El", or
			// "Electr". We have to do this in this
			// way because the accents are not correctly interpreted
			input = "Parciales$Plan[grep('Comunicaciones', Parciales$Plan)] <- 'Comunicaciones'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[grep('Electr', Parciales$Plan)] <- 'Tronica'"; // Instead of 'Electronica', because
																					// it would
			System.out.println("	" + input); // be caught by next grep
			c.voidEval(input);
			input = "Parciales$Plan[grep('El', Parciales$Plan)] <- 'Gr.Ing.Eléctric-09'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[which(Parciales$Plan=='Comunicaciones')] <- 'Gr.Ing.Elect.Co-09'";
			System.out.println("	" + input);
			c.voidEval(input);
			input = "Parciales$Plan[which(Parciales$Plan=='Tronica')] <- 'Gr.Ing.Electrón-09'";
			System.out.println("	" + input);
			c.voidEval(input);

			// Convert the character fields to factors and numeric fields to numeric type
			input = "source('Rscripts/correctSchema.R')";
			System.out.println("	" + input);
			c.voidEval(input);

			// Finally we save the data in Parciales.RData
			input = "save(Parciales, file='Updates/" + current_year + "/Parciales/Parciales.RData')";
			System.out.println("	" + input);
			c.voidEval(input);

			updated = makePredictions(c);
			
			// Detach or unload package gdata so that function startsWith from base package is not masked
			input = "detach(package:gdata)";
			System.out.println("	" + input);
			c.voidEval(input);
			
		} catch (Exception e) {
			System.out.println("	An error ocurred during the request to Rserve");
			System.out.println();
		}
		
		return updated;
	}
}