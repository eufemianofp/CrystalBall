import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;

public class Rserve {

	private static Process pr;

	// Creates the connection to Rserve, loads the functions and libraries and sets
	// the working directory
	public static RConnection connect() {

		RConnection c = null;
		try {
			// Attempts to create a new RConnection
			c = new RConnection();

		} catch (RserveException e) {
			System.out.println("	Unable to establish a connection to Rserve");
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("	Unable to establish a connection to Rserve");
			e.printStackTrace();
		}
		return c;
	}

	public static void loadData(RConnection c) {

		String wd = AuxiliaryFunctions.getWD();
		String currentYear = AuxiliaryFunctions.getCurrentYear();

		try {
			// Loads the historical data
			String load_all_data = "load('" + wd + "Data/AllData.RData')";
			System.out.println("	" + load_all_data);
			c.voidEval(load_all_data);

		} catch (RserveException e) {
			System.out.println("	Error loading all data in Rserve");
			System.out.println();
			e.printStackTrace();

		} catch (Exception e) {
			System.out.println();
			e.printStackTrace();
		}
		
		// Try to load mit-term exams
		try {
			String load_parciales = "load('" + wd + "Updates/" + currentYear + "/Parciales/Parciales.RData')";
			System.out.println("	" + load_parciales);
			c.voidEval(load_parciales);
			
		} catch (RserveException e) {
			System.out.println("	Error loading mid-term exams in Rserve");
			System.out.println();
			e.printStackTrace();

		} catch (Exception e) {
			System.out.println();
			e.printStackTrace();
		}
		
		// Try to load predictions (may not yet be available)
		try {
			String load_predicciones = "load('" + wd + "Updates/" + currentYear + "/Predicciones.RData')";
			System.out.println("	" + load_predicciones);
			c.voidEval(load_predicciones);
			
		} catch (RserveException e) {
			System.out.println("	Error loading predictions in Rserve. They are probably not available yet.");
			System.out.println();
			// e.printStackTrace();

		} catch (Exception e) {
			System.out.println();
			e.printStackTrace();
		}
		
	}

	private static boolean startUp() {

		boolean ready = false; // a variable to check whether Rserve was started up

		String command = "R CMD Rserve --vanilla";
		System.out.println("	Command run to start up Rserve: " + command);

		try {
			pr = Runtime.getRuntime().exec(command);
			pr.waitFor();

			// Checks whether Rserve was actually started
			String line = null;
			BufferedReader reader = new BufferedReader(new InputStreamReader(pr.getInputStream()));
			while ((line = reader.readLine()) != null) {
				if (line.contains("Rserv started"))
					ready = true;
			}
		} catch (IOException e) {
			System.out.println("	IOException: Unable to start Rserve");
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("	Exception: Unable to start Rserve");
			e.printStackTrace();
		}

		if (!ready)
			System.out.println("	Unable to start Rserve");

		return ready;
	}

	public static RConnection startUpAndConnect() {

		RConnection c = null;

		// If Rserve started up, create a connection to Rserve
		if (startUp()) {
			System.out.println("	Rserve started up successfully");
			c = connect();
		}

		// If connection was established
		if (c != null) {
			System.out.println("	Setting up R working directory");
			setWD(c);
			System.out.println("	Loading Rdata");
			loadData(c);
		}
		return c;
	}

	private static void setWD(RConnection c) {

		try {
			// Sets the new working directory, just for Rserve session
			c.voidEval("setwd('" + AuxiliaryFunctions.getWD() + "')");
		} catch (RserveException e) {
			System.out.println("	An error ocurred when changing the Rserve working directory");
			System.out.println();
			e.printStackTrace();
		}
	}

	public static void shutDown(RConnection c) {

		try {
			// Tries to shut Rserve down
			c.shutdown();
			System.out.println("	Rserve was shut down");
		} catch (RserveException e) {
			System.out.println("	Unable to shut Rserve down");
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("	Unable to shut Rserve down");
			e.printStackTrace();
		}
	}

}
