import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections4.ListUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.rosuda.REngine.Rserve.RConnection;

@WebServlet("/ConnectionToRserve")
public class ConnectionToRserve extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private RConnection c;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("--> Entering to servlet " + getServletName() + ".java");

		// Checks that the user logged in
		boolean session = AuxiliaryFunctions.checkSession(request);
		if (!session)
			response.sendRedirect("index.html");

		// Gets the connection to Rserve
		c = (RConnection) request.getSession().getAttribute("RConnection");

		// Receives the option chosen by the user
		String option = request.getParameter("option");
		System.out.println("	Option: " + option);

		// A long if...else if...else statement with all the possible cases
		if (option != null) {

			// Defines the content type of the response
			response.setContentType("text/html");

			// Creates the PrintWriter to send the response
			PrintWriter out = AuxiliaryFunctions.getPrintWriter(response);

			// Initializes the variable that will hold the response text
			String text = "";

			if (option.equals("alumnos")) {

				String year = request.getParameter("year");
				text = alumnos(year);

			} else if (option.equals("buscar")) {

				String carnet = request.getParameter("carnet");
				text = buscar(carnet);
				if (text.startsWith("{"))
					response.setContentType("application/json");

			} else if (option.equals("cargarCursos")) {

				boolean currentYear = Boolean.parseBoolean(request.getParameter("currentYear"));
				text = cargarCursos(currentYear);

			} else if (option.equals("generateReport")) {

				response.setContentType("application/json");
				text += generateReport(request);

			} else if (option.equals("getCurrentYear")) {

				response.setContentType("application/json");
				System.out.println("	Getting current academic year.");
				text += "{\"currentYear\": \"" + AuxiliaryFunctions.getCurrentYear() + "\"}";

			} else if (option.equals("loadReports")) {

				response.setContentType("application/json");

				String reports = loadReports();
				if (reports == null)
					text = "{\"success\": \"false\"}";
				else
					text = reports;

			} else if (option.equals("modifyReport")) {

				response.setContentType("application/json");
				int cReport = Integer.parseInt(request.getParameter("cReport"));
				text = modifyReport(request, cReport);

			} else if (option.equals("predicciones")) {

				String carnet = request.getParameter("carnet");
				text = predictions(carnet);

			} else if (option.equals("removeReport")) {

				response.setContentType("application/json");
				int cReport = Integer.parseInt(request.getParameter("cReport"));
				text = removeReport(cReport);

			} else if (option.equals("resultados")) {

				String carnet = request.getParameter("carnet");
				text = results(carnet);

			} else if (option.equals("semester1Uploaded")) {

				response.setContentType("application/json");

				if (RFunctions.isSemester1Uploaded(c))
					text = "{\"uploaded\": \"true\"}";
				else
					text = "{\"uploaded\": \"false\"}";

			} else if (option.equals("state")) {
				text = state();
			}

			// Outputs the response to the user
			out.println(text);
		}

		System.out.println("<-- End of servlet " + getServletName() + ".java");
		System.out.println();
	}

	private String alumnos(String year) {

		String text = "";
		String[] alumnos = RFunctions.alumnos(c, year);

		// Builds the response
		for (String alumno : alumnos)
			text += "<a href='#'><li class='list-group-item'>" + alumno + "</li></a>";
		return text;
	}

	private double bound(double nota) {

		if (nota < 0)
			nota = 0;
		else if (nota > 10)
			nota = 10;
		return nota;
	}

	private String buscar(String carnet) {

		String text = "";
		int[] carnets = RFunctions.buscar(c, carnet);

		if (carnets != null && carnets.length != 0) {
			for (int i = 0; i < carnets.length; i++) {
				text += "<a href='#'><li class='list-group-item'>" + carnets[i] + "</li></a>";
			}
		} else {
			text += "{\"existe\": \"false\"}";
		}
		return text;
	}

	private String cargarCursos(boolean currentYear) {

		String text = "";
		String[] cursos = RFunctions.cargarCursos(c);

		// Builds the response
		text += "<option selected>-- Elija un curso --</option>";
		for (String curso : cursos)
			text += "<option>" + curso + "</option>";
		if (currentYear)
			text += "<option>" + AuxiliaryFunctions.getCurrentYear() + "</option>";
		return text;
	}

	private String datosAlumno(String[] datos, String carnet, String currentYear, String studentYear) {

		String text = "";
		
		if (datos[0] == null) {
			text += "<p><strong><u>Nombre</u></strong>: no disponible </p>";
		} else if (datos[0].equals("NA")) {
			text += "<p><strong><u>Nombre</u></strong>: no disponible </p>";
		} else {
			text += "<p><strong><u>Nombre</u></strong>: " + datos[0] + " </p>";
		}
		
		text += "<p><strong><u>Curso</u></strong>: " + datos[1] + "</p>";
		text += "<p><strong><u>Grado</u></strong>: ";
		String grado = datos[3];
		
		// Because grado has a special name in the RData, we convert it to a readable
		// name
		if (grado.equals("Gr.Ing.Org.Ind-09")) {
			text += "Ingeniería en Organización Industrial";
		} else if (grado.equals("Gr.Ing.Tecn.Ind-09")) {
			text += "Ingeniería en Tecnologías Industriales";
		} else if (grado.equals("Gr.Ing.Mec")) {
			text += "Ingeniería Mecánica";
		} else if (grado.equals("Gr.Ing.Electr")) {
			text += "Ingeniería Electrónica Industrial";
		} else if (grado.equals("Gr.Ing.El")) {
			text += "Ingeniería Eléctrica";
		} else if (grado.equals("Gr.Ing.Biom")) {
			text += "Ingeniería Biomédica";
		} else if (grado.equals("Gr.Ing.Dis.Ind.-09")) {
			text += "Ingeniería en Diseño Industrial y Desarrollo de Productos";
		} else if (grado.equals("Gr.Ing.Sist.Tel-09")) {
			text += "Ingeniería en Sistemas de Telecomunicación";
		} else if (grado.equals("Gr.Ing.Elect.Co-09")) {
			text += "Ingeniería en Electrónica de Comunicaciones";
		} else {
			text += grado;
		}
		text += "</p>";
		text += "<p><strong><u>Procedencia</u></strong>: " + datos[6] + "</p>";

		// To distinguish if a mark is not available because it hasn't been uploaded yet
		// or because it's
		// never been uploaded
		String noDisponible = "";
		if (studentYear.equals(currentYear))
			noDisponible = "Pendiente";
		else
			noDisponible = "Nota no disponible";

		text += "<p><strong><u>Nota PAU</u></strong>: " + (datos[10].equals("NA") ? noDisponible : datos[10]) + "</p>";

		return text;
	}

	private String generateReport(HttpServletRequest request) {

		String text = "{\"success\": \"false\"}";

		try {
			// Receives the report values
			String report_title = request.getParameter("report_title");
			JSONArray graphs = new JSONArray(request.getParameter("graphs"));
			JSONArray subjects = new JSONArray(request.getParameter("subjects"));
			JSONArray years = new JSONArray(request.getParameter("years"));
			JSONArray titles = new JSONArray(request.getParameter("titles"));
			JSONArray comments = new JSONArray(request.getParameter("comments"));

			/*
			 * FIRST WE HAVE TO CREATE THE REPORT'S FOLDER
			 */

			// Here we create the folder. If exists, creates a new one with an alternative
			// name
			String wd = AuxiliaryFunctions.getWD();
			String folderName = "";

			File folder = new File(wd + "/Reports/" + report_title);

			// Checks the existence the a previous folder
			if (folder.exists())
				folderName = AuxiliaryFunctions.getFolderName(1, report_title);
			else
				folderName = report_title;

			folder = new File(wd + "/Reports/" + folderName);
			folder.mkdir();

			/*
			 * NOW WE SAVE THE REPORT IN THE DATABASE
			 */

			// Establish the connection to the database
			Connection connection = AuxiliaryFunctions.connectToDB();

			// If connection was not made, returns with false
			if (connection == null)
				return text;

			// PreparedStatement allows to precompile SQL queries to the database
			PreparedStatement prepStatement = null;

			// First inserts the report with its title and its folderName in the table
			// "Reports"
			String SQL = "INSERT INTO Reports (Title, folderName) VALUES (?,?);";
			try {
				prepStatement = connection.prepareStatement(SQL);
				prepStatement.setString(1, report_title);
				prepStatement.setString(2, folderName);
				prepStatement.executeUpdate();
			} catch (SQLException e) {
				System.out.println("	Error trying to insert the report title: " + report_title);
				System.out.println();
				e.printStackTrace();
				return text;
			}

			// Retrieves the cReport of the inserted report
			SQL = "SELECT @@Identity AS cReport FROM Reports;";
			long key;
			try {
				prepStatement = connection.prepareStatement(SQL);
				ResultSet rs = prepStatement.executeQuery();
				rs.next();
				key = rs.getLong("cReport");
				prepStatement.close();
			} catch (SQLException sqle) {
				System.out.println("	Error trying to get the auto-generated key");
				System.out.println();
				sqle.printStackTrace();
				return text;
			}

			// Now iterates along all the graphs added to the report, and adds them to the
			// table "GraphsXReport"
			SQL = "INSERT INTO GraphsXReport (cReport, Type, Subject, Year, Title, Comment) "
					+ "VALUES (?, ?, ?, ?, ?, ?);";
			int cReport = (int) key;
			try {
				prepStatement = connection.prepareStatement(SQL);
				for (int i = 0; i < graphs.length(); i++) {
					prepStatement.setInt(1, cReport);
					prepStatement.setString(2, graphs.getString(i));
					prepStatement.setString(3, subjects.getString(i));
					prepStatement.setString(4, years.getString(i));
					prepStatement.setString(5, titles.getString(i));
					prepStatement.setString(6, comments.getString(i));
					prepStatement.addBatch();
				}
				prepStatement.executeBatch();
				prepStatement.close();
				connection.close();
			} catch (SQLException sqle) {
				System.out.println("	Error trying to insert the graphs in the database.");
				System.out.println();
				sqle.printStackTrace();
				return text;
			}

			/*
			 * NOW WE HAVE TO GENERATE THE NOZZLE.R1 REPORT
			 */
			String reportPath = RFunctions.generateReport(c, report_title, graphs, subjects, years, titles, comments,
					folderName);
			if (reportPath != null)
				text = "{\"reportPath\": \"" + reportPath + "\", \"success\": true}";
		} catch (JSONException jsone) {
			System.out.println("	Error loading the JSON objects");
			System.out.println();
		}
		System.out.println("	" + text);
		return text;
	}

	private String isFail(String nota) {

		String result = "";
		if (nota.equals("NA"))
			return "<tr>";

		double nota_double = Double.parseDouble(nota);

		if (nota_double < 5) {
			result = "<tr class='suspenso'>";
		} else if (nota_double >= 9) {
			result = "<tr class='sobresaliente'>";
		} else {
			result = "<tr>";
		}
		return result;
	}

	private String loadReports() {

		String text = "{\"success\": \"false\"}";

		JSONArray reports = new JSONArray();
		JSONObject report = new JSONObject();
		JSONObject graphsXreport = new JSONObject();

		JSONArray cReports = new JSONArray();
		JSONArray report_titles = new JSONArray();
		JSONArray graph_types = new JSONArray();
		JSONArray subjects = new JSONArray();
		JSONArray years = new JSONArray();
		JSONArray graph_titles = new JSONArray();
		JSONArray comments = new JSONArray();

		// Establish the connection to the database
		Connection connection = AuxiliaryFunctions.connectToDB();

		// If connection was not made, returns with false
		if (connection == null)
			return text;

		// PreparedStatement allows to precompile SQL queries to the database
		PreparedStatement prepStatement = null;

		// First inserts the report with its title in the table "Reports"
		String SQL = "SELECT cReport, Title FROM Reports ORDER BY Title";
		try {
			prepStatement = connection.prepareStatement(SQL);
			ResultSet rs = prepStatement.executeQuery();
			while (rs.next()) {
				cReports.put(rs.getInt("cReport"));
				report_titles.put(rs.getString("Title"));
			}
		} catch (SQLException sqle) {
			System.out.println("	Error trying to retrieve the reports from the database.");
			System.out.println();
			sqle.printStackTrace();
			return text;
		}

		// Now retrieves all the graphs from the table "GraphsXReport", for each Report
		for (int i = 0; i < cReports.length(); i++) {
			SQL = "SELECT cReport, Type, Subject, Year, Title, Comment FROM GraphsXReport WHERE cReport=?";
			try {
				// We set 2 ResultSet properties in order to be able to use the function
				// "isLast()" from ResultSet
				prepStatement = connection.prepareStatement(SQL, ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				prepStatement.setInt(1, cReports.getInt(i));
				ResultSet rs = prepStatement.executeQuery();
				while (rs.next()) {
					// Adds next graph to the current report
					graph_types.put(rs.getString("Type"));
					subjects.put(rs.getString("Subject"));
					years.put(rs.getString("Year"));
					graph_titles.put(rs.getString("Title"));
					comments.put(rs.getString("Comment"));
				}
				// Builds the JSON structure
				graphsXreport.put("types", graph_types);
				graphsXreport.put("subjects", subjects);
				graphsXreport.put("years", years);
				graphsXreport.put("titles", graph_titles);
				graphsXreport.put("comments", comments);

				String report_title = report_titles.getString(i);

				report.put("cReport", cReports.getInt(i));
				report.put("report_title", report_title);
				report.put("reportPath", "Reports/" + report_title + "/" + report_title + ".html");
				report.put("graphs", graphsXreport);

				reports.put(report);

				// Resets the values of the temporal variables
				graph_types = new JSONArray();
				subjects = new JSONArray();
				years = new JSONArray();
				graph_titles = new JSONArray();
				comments = new JSONArray();
				graphsXreport = new JSONObject();
				report = new JSONObject();
			} catch (SQLException sqle) {
				System.out.println("	Error trying to retrieve the reports from the database.");
				System.out.println();
				sqle.printStackTrace();
				return text;
			} catch (JSONException jsone) {
				System.out.println("	Error trying to retrieve the reports from the database.");
				System.out.println();
				jsone.printStackTrace();
				return text;
			}
		}

		System.out.println("	" + reports);
		text = reports.toString();

		return text;
	}

	private String modifyReport(HttpServletRequest request, int cReport) {

		String text = "{\"success\": \"false\"}";

		try {
			// Receives the report values
			String report_title = request.getParameter("report_title");
			JSONArray graphs = new JSONArray(request.getParameter("graphs"));
			JSONArray subjects = new JSONArray(request.getParameter("subjects"));
			JSONArray years = new JSONArray(request.getParameter("years"));
			JSONArray titles = new JSONArray(request.getParameter("titles"));
			JSONArray comments = new JSONArray(request.getParameter("comments"));

			/*
			 * THEN WE REMOVE THE PREVIOUS REPORT GRAPHS, AND ADD THE NEW ONES
			 */

			// Establish the connection to the database
			Connection connection = AuxiliaryFunctions.connectToDB();

			// If connection was not made, returns with false
			if (connection == null)
				return text;

			// PreparedStatement allows to precompile SQL queries to the database
			PreparedStatement prepStatement = null;

			// First removes the old graphs
			String SQL = "DELETE FROM GraphsXReport WHERE cReport=?;";
			try {
				prepStatement = connection.prepareStatement(SQL);
				prepStatement.setInt(1, cReport);
				prepStatement.executeUpdate();
			} catch (SQLException e) {
				System.out.println("	Error trying to insert the report title: " + report_title);
				System.out.println();
				e.printStackTrace();
				return text;
			}

			// Then we retrieve the old report name, in order to delete its folder a few
			// lines below
			SQL = "SELECT folderName FROM Reports WHERE cReport=?;";
			String oldReportFolder = null;
			try {
				prepStatement = connection.prepareStatement(SQL);
				prepStatement.setInt(1, cReport);
				ResultSet rs = prepStatement.executeQuery();
				rs.next();
				oldReportFolder = rs.getString("folderName");
			} catch (SQLException e) {
				System.out.println("	Error trying to retrieve the old report name");
				System.out.println();
				e.printStackTrace();
				return text;
			}

			/*
			 * NOW WE REMOVE THE FOLDER WITH THE REPORT
			 */
			String wd = AuxiliaryFunctions.getWD();

			// Builds the old folder path and gets it into a file object
			File oldFolder = new File(wd + "/Reports/" + oldReportFolder);

			// First we have to delete all the files inside the folder
			String[] filesInFolder = oldFolder.list();
			for (String file : filesInFolder) {
				File currentFile = new File(oldFolder.getPath(), file);
				System.gc(); // this is needed to delete the currentFile, still don't know why
				currentFile.delete();
			}
			// Now we can remove the folder
			oldFolder.delete();

			/*
			 * AND NOW WE HAVE TO CREATE THE NEW REPORT'S FOLDER
			 */
			String folderName = "";
			File folder = new File(wd + "/Reports/" + report_title);

			// Checks the existance of a previous report folder with the same name,
			// different from this one
			if (folder.exists() && !report_title.equals(oldReportFolder)) {
				folderName = AuxiliaryFunctions.getFolderName(1, report_title);
				report_title = folderName;
			} else
				folderName = report_title;

			folder = new File(wd + "/Reports/" + folderName);
			folder.mkdir();

			// Now updates the title and the folderName of the report
			SQL = "UPDATE Reports SET Title=?, folderName=? WHERE cReport=?;";
			try {
				prepStatement = connection.prepareStatement(SQL);
				prepStatement.setString(1, report_title);
				prepStatement.setString(2, folderName);
				prepStatement.setInt(3, cReport);
				prepStatement.executeUpdate();
			} catch (SQLException e) {
				System.out.println("	Error trying to insert the report title: " + report_title);
				System.out.println();
				e.printStackTrace();
				return text;
			}

			// Finally inserts the new graphs
			SQL = "INSERT INTO GraphsXReport (cReport, Type, Subject, Year, Title, Comment) "
					+ "VALUES (?, ?, ?, ?, ?, ?);";
			try {
				prepStatement = connection.prepareStatement(SQL);
				for (int i = 0; i < graphs.length(); i++) {
					prepStatement.setInt(1, cReport);
					prepStatement.setString(2, graphs.getString(i));
					prepStatement.setString(3, subjects.getString(i));
					prepStatement.setString(4, years.getString(i));
					prepStatement.setString(5, titles.getString(i));
					prepStatement.setString(6, comments.getString(i));
					prepStatement.addBatch();
				}
				prepStatement.executeBatch();
				prepStatement.close();
				connection.close();
			} catch (SQLException sqle) {
				System.out.println("	Error trying to insert the new graphs in the database.");
				System.out.println();
				sqle.printStackTrace();
				return text;
			}

			/*
			 * NOW WE HAVE TO GENERATE THE NEW NOZZLE.R REPORT
			 */
			String reportPath = RFunctions.generateReport(c, report_title, graphs, subjects, years, titles, comments,
					folderName);
			text = "{\"reportPath\": \"" + reportPath + "\", \"success\": true}";

		} catch (JSONException jsone) {
			System.out.println("	Error loading the JSON objects");
			System.out.println();
		}

		return text;
	}

	private double nota(String nota) {
		double grade = (double) Math.round(Double.parseDouble(nota) * 10) / 10; // 2 decimal precision
		return grade;
	}

	private String removeReport(int cReport) {

		String text = "{\"success\": \"false\"}";

		// Establish the connection to the database
		Connection connection = AuxiliaryFunctions.connectToDB();

		// If connection was not made, returns with false
		if (connection == null)
			return text;

		// PreparedStatement allows to precompile SQL queries to the database
		PreparedStatement prepStatement = null;
		
		// First deletes all the graphs related to the report in the table
		// "GraphsXReport"
		String SQL = "DELETE FROM GraphsXReport WHERE cReport=?;";
		try {
			prepStatement = connection.prepareStatement(SQL);
			prepStatement.setInt(1, cReport);
			prepStatement.executeUpdate();
		} catch (SQLException e) {
			System.out.println("	Error trying to delete the graphs of the report: " + cReport);
			System.out.println();
			e.printStackTrace();
			return text;
		}

		// Now retrieves the name of the report in order to remove its folder some lines
		// below
		SQL = "SELECT Title FROM Reports WHERE cReport=?;";
		String report_title = null;
		try {
			prepStatement = connection.prepareStatement(SQL);
			prepStatement.setInt(1, cReport);
			ResultSet rs = prepStatement.executeQuery();
			rs.next();
			report_title = rs.getString("Title");
		} catch (SQLException e) {
			System.out.println("	Error trying to delete the report: " + cReport);
			System.out.println();
			e.printStackTrace();
			return text;
		}

		// Now deletes the report in the table "Reports"
		SQL = "DELETE FROM Reports WHERE cReport=?;";
		try {
			prepStatement = connection.prepareStatement(SQL);
			prepStatement.setInt(1, cReport);
			prepStatement.executeUpdate();
		} catch (SQLException e) {
			System.out.println("	Error trying to delete the report: " + cReport);
			System.out.println();
			e.printStackTrace();
			return text;
		}

		/*
		 * NOW WE REMOVE THE FOLDER WITH THE REPORT
		 */
		String wd = AuxiliaryFunctions.getWD();
		System.out.println("	Working directory: " + wd);
		
		if (report_title != null) {
			// Builds the old folder path and gets it into a file object
			File folder = new File(wd + "/Reports/" + report_title);

			// First we have to delete all the files inside the folder
			String[] filesInFolder = folder.list();
			
			if (filesInFolder != null) {
				for (String file : filesInFolder) {
					File currentFile = new File(folder.getPath(), file);
					System.out.println("	Deleted file: " + currentFile.getPath());
					currentFile.delete();
				}
			}
			
			// Now we can remove the folder
			if (folder != null) {
				System.out.println("	Deleted folder: " + folder.getPath());
				folder.delete();
			}
		}

		System.out.println("	Report '" + report_title + "' removed successfully.");
		text = "{\"success\": \"true\"}";
		return text;
	}

	private String results(String carnet) {

		String text = "";
		
		String currentYear = AuxiliaryFunctions.getCurrentYear();
		String studentYear = RFunctions.getStudentYear(c, carnet);
		
		System.out.println("	Current year: " + currentYear);
		System.out.println("	Student year: " + studentYear);
		
		String[] notas = RFunctions.datosAlumno(c, carnet, currentYear, studentYear);

		text += datosAlumno(notas, carnet, currentYear, studentYear);

		text += "<!-- Table -->" + "<table class='table table-hover table-condensed'>" + "<thead>" + "<tr>"
				+ "<th>Examen</th>" + "<th>Nota</th>" + "</tr>" + "</thead>" + "<tbody>";

		String noDisponible = "";
		if (studentYear.equals(currentYear))
			noDisponible = "Pendiente";
		else
			noDisponible = "Nota no disponible";

		/*
		 * PARCIALES 1er CUATRIMESTRE
		 */
		text += isFail(notas[12]);
		text += "<td>Previo Mates</td><td>" + (notas[12].equals("NA") ? noDisponible : nota(notas[12]) + "</td>");
		text += "</tr>";
		text += isFail(notas[11]);
		text += "<td>Previo Física</td><td>" + (notas[11].equals("NA") ? noDisponible : nota(notas[11]) + "</td>");
		text += "</tr>";

		text += isFail(notas[13]);
		text += "<td>Peq1 Cálculo</td><td>" + (notas[13].equals("NA") ? noDisponible : nota(notas[13]) + "</td>");
		text += "</tr>";
		text += isFail(notas[14]);
		text += "<td>Peq1 Álgebra</td><td>" + (notas[14].equals("NA") ? noDisponible : nota(notas[14]) + "</td>");
		text += "</tr>";

		text += isFail(notas[16]);
		text += "<td>Parcial Cálculo</td><td>" + (notas[16].equals("NA") ? noDisponible : nota(notas[16]) + "</td>");
		text += "</tr>";
		text += isFail(notas[15]);
		text += "<td>Parcial Álgebra</td><td>" + (notas[15].equals("NA") ? noDisponible : nota(notas[15]) + "</td>");
		text += "</tr>";

		text += isFail(notas[17]);
		text += "<td>Peq2 Cálculo</td><td>" + (notas[17].equals("NA") ? noDisponible : nota(notas[17]) + "</td>");
		text += "</tr>";

		text += isFail(notas[18]);
		text += "<td>Física Electricidad</td><td>"
				+ (notas[18].equals("NA") ? noDisponible : nota(notas[18]) + "</td>");
		text += "</tr>";

		text += isFail(notas[19]);
		text += "<td>Física Ondas</td><td>" + (notas[19].equals("NA") ? noDisponible : nota(notas[19]) + "</td>");
		text += "</tr>";

		text += isFail(notas[20]);
		text += "<td>Parcial Informática</td><td>"
				+ (notas[20].equals("NA") ? noDisponible : nota(notas[20]) + "</td>");
		text += "</tr>";

		/*
		 * FINALES 1er CUATRIMESTRE
		 */
		text += isFail(notas[21]);
		text += "<td><strong>Final Matemáticas</strong></td><td><strong>"
				+ (notas[21].equals("NA") ? noDisponible : nota(notas[21]) + "</strong></td>");
		text += "</tr>";
		text += isFail(notas[23]);
		text += "<td><strong>Final Física</strong></td><td><strong>"
				+ (notas[23].equals("NA") ? noDisponible : nota(notas[23]) + "</strong></td>");
		text += "</tr>";
		text += isFail(notas[22]);
		text += "<td><strong>Final Informática</strong></td><td><strong>"
				+ (notas[22].equals("NA") ? noDisponible : nota(notas[22]) + "</strong></td>");
		text += "</tr>";
		text += isFail(notas[24]);
		text += "<td><strong>Final Antropología</strong></td><td><strong>"
				+ (notas[24].equals("NA") ? noDisponible : nota(notas[24]) + "</strong></td>");
		text += "</tr>";
		text += isFail(notas[25]);
		text += "<td><strong>Final ECC</strong></td><td><strong>"
				+ (notas[25].equals("NA") ? noDisponible : nota(notas[25]) + "</strong></td>");
		text += "</tr>";

		/*
		 * PARCIALES 2do CUATRIMESTRE
		 */
		text += isFail(notas[26]);
		text += "<td>Parcial Matemáticas II</td><td>"
				+ (notas[26].equals("NA") ? noDisponible : nota(notas[26]) + "</td>");
		text += "</tr>";

		text += isFail(notas[27]);
		text += "<td>Parcial Estadística</td><td>"
				+ (notas[27].equals("NA") ? noDisponible : nota(notas[27]) + "</td>");
		text += "</tr>";

		if (!studentYear.equals(currentYear)) {
			/*
			 * FINALES 2do CUATRIMESTRE
			 */
			text += isFail(notas[28]);
			text += "<td><strong>Final Matemáticas II</strong></td><td><strong>"
					+ (notas[28].equals("NA") ? noDisponible : nota(notas[28]) + "</strong></td>");
			text += "</tr>";
			text += isFail(notas[29]);
			text += "<td><strong>Final Física II</strong></td><td><strong>"
					+ (notas[29].equals("NA") ? noDisponible : nota(notas[29]) + "</strong></td>");
			text += "</tr>";
			text += isFail(notas[30]);
			text += "<td><strong>Final Estadística</strong></td><td><strong>"
					+ (notas[30].equals("NA") ? noDisponible : nota(notas[30]) + "</strong></td>");
			text += "</tr>";
			text += isFail(notas[31]);
			text += "<td><strong>Final Economía y Empresa</strong></td><td><strong>"
					+ (notas[31].equals("NA") ? noDisponible : nota(notas[31]) + "</strong></td>");
			text += "</tr>";
			text += isFail(notas[32]);
			text += "<td><strong>Final Antropología II</strong></td><td><strong>"
					+ (notas[32].equals("NA") ? noDisponible : nota(notas[32]) + "</strong></td>");
			text += "</tr>";
			text += isFail(notas[33]);
			text += "<td><strong>Final ECC II</strong></td><td><strong>"
					+ (notas[33].equals("NA") ? noDisponible : nota(notas[33]) + "</strong></td>");
			text += "</tr>";
		}

		text += "</tbody>";
		text += "</table>";

		return text;
	}

	private String predictions(String carnet) {

		String text = "";

		String currentYear = AuxiliaryFunctions.getCurrentYear();
		String studentYear = RFunctions.getStudentYear(c, carnet);
		
		String[] notas = RFunctions.datosAlumno(c, carnet, currentYear, studentYear);
		String[] predicciones = RFunctions.getPredicciones(c, carnet);

		if (predicciones == null) {
			System.out.println("	No hay predicciones disponibles porque todavía no se han subido notas parciales");
			text += "<tr><td>No hay predicciones disponibles porque todavía no se han subido notas parciales.</td></tr>";
			return text;
		}

		text += datosAlumno(notas, carnet, currentYear, studentYear);
		text += "<p><strong><u>Nivel de confianza</u></strong>: 80%</p>";

		text += "<!-- Table -->" + "<table class='table table-hover table-condensed'>" + "<thead>" + "<tr>"
				+ "<th>Examen</th>" + "<th>Nota Esperada</th>" + "<th>Mínima</th>" + "<th>Máxima</th>"
				+ "<th>Prob. aprobar (%)" + "</tr>" + "</thead>" + "<tbody>";

		boolean semester1Uploaded = false;
		semester1Uploaded = RFunctions.isSemester1Uploaded(c);
		
		if (predicciones[2] != null) {
			if (studentYear.equals(currentYear)) {
				if (!semester1Uploaded) {
					text += showPredictions("semester1", predicciones);
				} else {
					text += showPredictions("semester2", predicciones);
				}
			} else {
				text += showPredictions("semester2", predicciones);
			}
		} else {
			text += "<tr><td>No hay predicciones disponibles porque todavía no se han subido notas parciales.</td></tr>";
		}

		text += "</tbody>";
		text += "</table>";

		return text;
	}

	private String showPredictions(String semester, String[] predicciones) {

		String text = "";

		if (semester.equals("semester1")) {
			text += isFail(String.valueOf(nota(predicciones[1])));
			text += "<td>Matemáticas</td>";
			text += "<td><strong>" + bound(nota(predicciones[1])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[2])) + "</td>";
			text += "<td>" + bound(nota(predicciones[3])) + "</td>";
			text += "<td>" + nota(predicciones[4]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[5])));
			text += "<td>Física</td>";
			text += "<td><strong>" + bound(nota(predicciones[5])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[6])) + "</td>";
			text += "<td>" + bound(nota(predicciones[7])) + "</td>";
			text += "<td>" + nota(predicciones[8]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[9])));
			text += "<td>Informática</td>";
			text += "<td><strong>" + bound(nota(predicciones[9])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[10])) + "</td>";
			text += "<td>" + bound(nota(predicciones[11])) + "</td>";
			text += "<td>" + nota(predicciones[12]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[13])));
			text += "<td>Antropología</td>";
			text += "<td><strong>" + bound(nota(predicciones[13])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[14])) + "</td>";
			text += "<td>" + bound(nota(predicciones[15])) + "</td>";
			text += "<td>" + nota(predicciones[16]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[17])));
			text += "<td>ECC</td>";
			text += "<td><strong>" + bound(nota(predicciones[17])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[18])) + "</td>";
			text += "<td>" + bound(nota(predicciones[19])) + "</td>";
			text += "<td>" + nota(predicciones[20]) + "</td>";
			text += "</tr>";
			
		} else if (semester.equals("semester2")) {
			text += isFail(String.valueOf(nota(predicciones[21])));
			text += "<td>Matemáticas II</td>";
			text += "<td><strong>" + bound(nota(predicciones[21])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[22])) + "</td>";
			text += "<td>" + bound(nota(predicciones[23])) + "</td>";
			text += "<td>" + nota(predicciones[24]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[25])));
			text += "<td>Física II</td>";
			text += "<td><strong>" + bound(nota(predicciones[25])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[26])) + "</td>";
			text += "<td>" + bound(nota(predicciones[27])) + "</td>";
			text += "<td>" + nota(predicciones[28]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[29])));
			text += "<td>Estadística</td>";
			text += "<td><strong>" + bound(nota(predicciones[29])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[30])) + "</td>";
			text += "<td>" + bound(nota(predicciones[31])) + "</td>";
			text += "<td>" + nota(predicciones[32]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[33])));
			text += "<td>Economía y Empresa</td>";
			text += "<td><strong>" + bound(nota(predicciones[33])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[34])) + "</td>";
			text += "<td>" + bound(nota(predicciones[35])) + "</td>";
			text += "<td>" + nota(predicciones[36]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[37])));
			text += "<td>Antropología II</td>";
			text += "<td><strong>" + bound(nota(predicciones[37])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[38])) + "</td>";
			text += "<td>" + bound(nota(predicciones[39])) + "</td>";
			text += "<td>" + nota(predicciones[40]) + "</td>";
			text += "</tr>";

			text += isFail(String.valueOf(nota(predicciones[41])));
			text += "<td>ECC II</td>";
			text += "<td><strong>" + bound(nota(predicciones[41])) + "</strong></td>";
			text += "<td>" + bound(nota(predicciones[42])) + "</td>";
			text += "<td>" + bound(nota(predicciones[43])) + "</td>";
			text += "<td>" + nota(predicciones[44]) + "</td>";
			text += "</tr>";
		}
		return text;
	}

	private String state() {

		String text = "";
		String curso = AuxiliaryFunctions.getCurrentYear();
		String[] uploadedGrades = RFunctions.state(c);
		String[] nombreNotas = { "Nota PAU", "Previo Mates", "Previo Física", "Peq1 Cálculo", "Peq1 Álgebra",
				"Parcial Álgebra", "Parcial Cálculo", "Peq2 Cálculo", "Física Electricidad", "Física Ondas",
				"Peq Informática", "Final Matemáticas", "Final Informática", "Final Física", "Final Antropología",
				"Final ECC", "Peq Mates II", "Peq Estadística" };

		text += "<p><strong><u>Curso</strong></u>: " + curso + "</p>";
		text += "<p><strong><u>Notas subidas</strong></u>:</p>";
		text += "<ul class='list-group' id='notasSubidas'>";
		if (uploadedGrades != null) {
			String[] todasLasNotas = RFunctions.getParcialesColnames(c);
			int pos;
			for (String mark : uploadedGrades) {
				pos = Arrays.asList(todasLasNotas).indexOf(mark);
				text += "<li class='list-group-item list-group-item-success'>" + nombreNotas[pos] + "</li>";
			}
		} else {
			text += "<li class='list-group-item list-group-item-warning'>No se ha subido ninguna nota</li>";
		}
		text += "</ul>";
		text += "<p><strong><u>Notas pendientes por subir</strong></u>:</p>";
		text += "<ul class='list-group' id='notasPendientes'>";

		// Some grades have been uploaded
		if (uploadedGrades != null) {
			// We get the subjects which haven't been uploaded yet
			String[] todasLasNotas = RFunctions.getParcialesColnames(c);
			List<String> diff = ListUtils.subtract(Arrays.asList(todasLasNotas), Arrays.asList(uploadedGrades));
			if (diff.size() == 0) {
				text += "<li class='list-group-item list-group-item-warning'>Ya ha subido todas las notas."
						+ " Pulse \"Empezar\" para empezar un nuevo curso.</li>";
				return text;
			} else {
				int pos;
				for (int i = 0; i < diff.size(); i++) {
					pos = Arrays.asList(todasLasNotas).indexOf(diff.get(i));
					text += "<li class='list-group-item list-group-item-danger'>" + nombreNotas[pos] + "</li>";
				}
			}
		} else {
			for (int i = 0; i < nombreNotas.length; i++) {
				text += "<li class='list-group-item list-group-item-danger'>" + nombreNotas[i] + "</li>";
			}
		}
		text += "</ul>";

		return text;
	}

	public void destroy() {
		super.destroy();
	}

}
