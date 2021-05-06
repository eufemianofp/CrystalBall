import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DownloadFile")
public class DownloadFile extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("--> Entering to servlet " + getServletName() + ".java");

		/*
		 * IF THERE ARE SOME UPLOADED MARKS, DOWNLOADS THE PREVIOUS UPLOADED EXCEL. IF
		 * NOT, DOWNLOADS THE MARKS TEMPLATE
		 */

		String currentYear = AuxiliaryFunctions.getCurrentYear();
		String yearFolder = AuxiliaryFunctions.getWD() + "/Updates/" + currentYear + "/Parciales";
		String filePath = null;

		File downloadFile = null;
		File[] lastUpdate = null;

		// Checks if there is a file in the LastUpdate folder
		lastUpdate = new File(yearFolder + "/LastUpdate").listFiles();

		if (lastUpdate.length == 0) {
			filePath = AuxiliaryFunctions.getWD() + "/Updates/Plantilla Notas.xlsx";
			downloadFile = new File(filePath);
		} else
			downloadFile = lastUpdate[0];

		// Generates an inputstream to handle the file
		FileInputStream inStream = new FileInputStream(downloadFile);

		// Gets MIME type of the file
		String mimeType = getServletContext().getMimeType(filePath);
		if (mimeType == null) {
			// Set to binary type if MIME mapping not found
			mimeType = "application/octet-stream";
		}

		// Modifies response
		response.setContentType(mimeType);
		response.setContentLength((int) downloadFile.length());

		// Forces download
		String headerKey = "Content-Disposition";
		String headerValue = String.format("attachment; filename=\"%s\"", "Plantilla Notas.xlsx");
		response.setHeader(headerKey, headerValue);

		// Obtains response's output stream
		OutputStream outStream = response.getOutputStream();

		byte[] buffer = new byte[4096];
		int bytesRead = -1;

		while ((bytesRead = inStream.read(buffer)) != -1) {
			outStream.write(buffer, 0, bytesRead);
		}

		inStream.close();
		outStream.close();

		System.out.println("	File " + downloadFile.getName() + " was downloaded successfully.");
		System.out.println("<-- End of servlet " + getServletName() + ".java");
		System.out.println();
	}
}