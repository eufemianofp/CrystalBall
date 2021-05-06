import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuxiliaryFunctions {

	private static String workingDirectory = null;
	private static String perlPath = null;
	private static String uploadsDirectory = null;

	
	public static String add_date_to_filename(String fileName) {

		StringBuffer sb = new StringBuffer(fileName);
		DateFormat dateFormat = new SimpleDateFormat("ddMMyyyy_HHmmss");
		sb.insert(sb.lastIndexOf("."), "-" + dateFormat.format(new Date()));
		return sb.toString();
	}
	
	
	public static File checkExist(String tipo, String filename, String current_year) {

		String current_year_folder_path = uploadsDirectory + File.separator + current_year;
		
		File file = null;

		// Formats the name of the saved file
		String filename_with_date = add_date_to_filename(filename);

		if (tipo.equals("Parciales")) {
			// Checks if there is a file in the LastUpdate folder
			System.out.println("	Year folder: " + current_year_folder_path);
			System.out.println("	Tipo: " + tipo);
			File[] lastUpdate = new File(current_year_folder_path + File.separator + tipo + File.separator + "LastUpdate").listFiles();
			
			if (lastUpdate.length == 0) {
				file = new File(current_year_folder_path + File.separator + tipo + File.separator + "LastUpdate" + File.separator + filename_with_date);
			
			} else {
				// If there is a file in the folder LastUpdate, we move it to its parent folder
				lastUpdate[0].renameTo(new File(current_year_folder_path + File.separator + tipo + File.separator + lastUpdate[0].getName()));
				// And now returns the path of the new file
				file = new File(current_year_folder_path + File.separator + tipo + File.separator + "LastUpdate" + File.separator + filename_with_date);
			}
			
		} else if (tipo.equals("Finales")) {
			file = new File(current_year_folder_path + File.separator + tipo + File.separator + filename_with_date);
			
		} else if (tipo.equals("ExamenesAdmision")) {
			file = new File(current_year_folder_path + File.separator + "Finales" + File.separator + tipo + File.separator + filename_with_date);
		}
		
		return file;
	}

	
	public static boolean checkSession(HttpServletRequest request) {
		return request.getSession(false) != null;
	}

	
	public static Connection connectToDB() {

		Connection connection = null;
		try {
			Class.forName("net.ucanaccess.jdbc.UcanaccessDriver"); // In Ubuntu
			String url = "jdbc:ucanaccess://" + workingDirectory + "CrystalBall.accdb";
			connection = DriverManager.getConnection(url);
			System.out.println("	Connected to DB");
		} catch (Exception ex) {
			System.out.println("	Couldn't connect to the database");
			System.out.println();
		}
		return connection;
	}

	
	public static boolean create_next_year_folders(String next_year) {
		
		String next_year_folder_path = uploadsDirectory + File.separator + next_year;
		File next_year_folder = new File(next_year_folder_path);
		
		if (!next_year_folder.exists()) {
			// Create directory structure for next year
			try {
				File lastUpdate = new File(next_year_folder_path + File.separator + "Parciales" + File.separator + "LastUpdate");
				boolean updated_parciales_folder = lastUpdate.mkdirs();

				File examenesAdmision = new File(next_year_folder_path + File.separator + "Finales" + File.separator + "ExamenesAdmision");
				boolean updated_finales_folder = examenesAdmision.mkdirs();
				
				return updated_parciales_folder && updated_finales_folder;
				
			} catch (Exception e) {
				System.out.println("	Could not create directories for next year " + next_year);
				System.out.println();
				e.printStackTrace();
				return false;
			}
		}
		
		return true;
	}
	
	
	public static String getYear(String type) {

		// Initial years
		int i = 2012;
		int j = 2013;

		String current_year = i + "-" + j;
		String next_year = (i + 1) + "-" + (j + 1);
		File next_year_folder = new File(uploadsDirectory + File.separator + next_year);
		
		while (next_year_folder.isDirectory()) {
			current_year = next_year;
			i++;
			j++;
			next_year = i + "-" + j;
			next_year_folder = new File(uploadsDirectory + File.separator + next_year);
		}
		
		if (type.equals("current")) {
			return current_year;
		} else if (type.equals("next")) {
			return next_year;
		} else {
			return current_year;
		}
		
	}
	
	
	public static String getCurrentYear() {
		return getYear("current");
	}
	

	public static String getFolderName(int i, String report_title) {

		// Reads the working directory
		String wd = AuxiliaryFunctions.getWD();
		String folderName = null;

		// If working directory was read, we try to check the existence of "folderName"
		File folder = null;
		if (wd != null) {
			folderName = report_title + "(" + i + ")";
			folder = new File(wd + "/Reports/" + folderName);
			if (folder.isDirectory()) { // if folder exists and is a directory
				folderName = getFolderName(i + 1, report_title);
			} else { // if folder doesn't exist
				return folderName;
			}
		}
		return folderName;
	}
	
	
	public static String getPerlPath() {

		if (perlPath != null)
			return perlPath;

		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(getWD() + "/PerlPath.txt"));
			String path = br.readLine();
			path = path.replace("\\", "/");
			perlPath = path;
		} catch (FileNotFoundException e) {
			System.out.println("	The file PerlPath.txt was not found.");
			System.out.println();
			e.printStackTrace();
		} catch (IOException e) {
			System.out.println("	There was a problem reading the PerlPath.txt");
			System.out.println();
			e.printStackTrace();
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return perlPath;
	}
	

	public static PrintWriter getPrintWriter(HttpServletResponse response) {

		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException io) {
			System.out.println("An error ocurred while creating the PrintWriter.");
			System.out.println();
			io.printStackTrace();
		}
		return out;
	}


	public static String getWD() {
		return workingDirectory;
	}
	

	public static String quitarTildesAsignatura(String subject) {

		if (subject.equals("Matemáticas"))
			subject = "Matematicas";
		else if (subject.equals("Física"))
			subject = "Fisica";
		else if (subject.equals("Informática"))
			subject = "Informatica";
		else if (subject.equals("Antropología"))
			subject = "Antropologia";
		else if (subject.equals("Matemáticas II"))
			subject = "MatematicasII";
		else if (subject.equals("Física II"))
			subject = "FisicaII";
		else if (subject.equals("Estadística y Probabilidad"))
			subject = "Estadistica";
		else if (subject.equals("Economía y Empresa"))
			subject = "EconomiayEmpresa";
		else if (subject.equals("Antropología II"))
			subject = "AntropologiaII";
		else if (subject.equals("ECC II"))
			subject = "ECCII";
		else if (subject.equals("Primer cuatrimestre"))
			subject = "PrimerSemestre";
		else if (subject.equals("Segundo cuatrimestre"))
			subject = "SegundoSemestre";
		else if (subject.equals("Todos los cursos"))
			subject = "Todas";

		return subject;
	}
	

	public static void setWD(String wd) {
		workingDirectory = wd;
		uploadsDirectory = wd + File.separator + "Updates";
	}
}
