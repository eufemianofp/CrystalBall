import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import org.rosuda.REngine.Rserve.RConnection;

@WebServlet("/UploadFile")
public class UploadFile extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("--> Entering to servlet " + getServletName() + ".java");

		String tipo = null;
		String current_year = AuxiliaryFunctions.getCurrentYear();
		String next_year = AuxiliaryFunctions.getYear("next");
		
		boolean excelUploaded = false;
		
		File excelPath = null;
		File csvFolderPath = null;
		
		PrintWriter out = AuxiliaryFunctions.getPrintWriter(response);
		try {
			boolean ismultipart = ServletFileUpload.isMultipartContent(request);
			if (!ismultipart) {
				// Unexpected error, petition is not containing a file
				out.println("{\"state\": \"not saved\"}");
				System.out.println("	File not saved");
				System.out.println("<-- End of servlet " + getServletName() + ".java");
				System.out.println();
				return;
			} else {
				response.setContentType("application/json");
				
				// Try to fetch attachments
				FileItemFactory factory = new DiskFileItemFactory();
				ServletFileUpload upload = new ServletFileUpload(factory);
				List<FileItem> items = null;
				
				try {
					items = upload.parseRequest(request);
					
				} catch (Exception e) {
					e.printStackTrace();
					out.println("{\"state\": \"not saved\"}");
					System.out.println("	File not saved");
					System.out.println("<-- End of servlet " + getServletName() + ".java");
					System.out.println();
					return;
				}
				// System.out.println("	Files number: " + items.size());
				// System.out.println("	Files: " + items);
				
				// Loop through attachments
				Iterator<FileItem> itr = items.iterator();
				while (itr.hasNext()) {
					FileItem item = itr.next();
					
					if (item.isFormField()) {
						
						tipo = item.getFieldName();
						System.out.println("	Type of upload: Notas " + tipo);
						
					} else {
						
						String fileName = item.getName();
						// System.out.println("	Item field name: " + item.getFieldName());
						System.out.println("	Item filename: " + fileName);
						
						if (tipo.equals("parciales")) {
							
							// Checks if the file already exists with the name uploaded. If it does, changes
							// its name. If it
							// doesn't, doesn't change the name. Anyway, it returns the absolute path where
							// to save the file
							File file = AuxiliaryFunctions.checkExist("Parciales", fileName, current_year);
							// Saves the file
							item.write(file);

							/*
							 * Now we have to call R to update the data with this Excel file
							 */
							// Gets the connection to Rserve
							RConnection c = (RConnection) request.getSession().getAttribute("RConnection");

							boolean updated = RFunctions.updateParciales(c, file.getPath());

							out.println("{\"state\": \"saved\", \"name\": \"" + fileName + "\", \"updated\": \""
									+ updated + "\"}");
							System.out.println("	File saved and updated=" + updated);
							System.out.println("<-- End of servlet " + getServletName() + ".java");
							System.out.println();
							return;
						
						} else if (tipo.equals("finales")) {
							
							File file = null;

							// The first file is an Excel file
							if (!excelUploaded) {
								// Returns a modified name for the file saved
								file = AuxiliaryFunctions.checkExist("Finales", fileName, current_year);
								excelPath = file;
								excelUploaded = true;
							} else {
								// Returns a modified name for the file saved
								file = AuxiliaryFunctions.checkExist("ExamenesAdmision", fileName, current_year);
								csvFolderPath = file.getParentFile();
							}

							if (file == null)
								return;

							// Saves the file
							item.write(file);
						} else {
							// Unexpected petition
							out.println("{\"state\": \"not saved\"}");
							System.out.println("	File not saved");
							System.out.println("<-- End of servlet " + getServletName() + ".java");
							System.out.println();
							return;
						}
					}
				} // end of while
				
				if (!excelUploaded) {
					out.println("{\"state\": \"not saved\"}");
					System.out.println("	File not saved");
					System.out.println("<-- End of servlet " + getServletName() + ".java");
					System.out.println();
					return;
				}

				/*
				 * Now we have to call R to update the R data with the Excel and .csv files
				 */
				// Gets the connection to Rserve
				RConnection c = (RConnection) request.getSession().getAttribute("RConnection");

				boolean next_year_folders_created = AuxiliaryFunctions.create_next_year_folders(next_year);
				boolean updated = RFunctions.updateFinales(c, excelPath.getPath(), csvFolderPath.getPath(), current_year, next_year);
				
				out.println("{\"state\": \"saved\", \"updated\": \"" + (updated && next_year_folders_created) + "\"}");
				System.out.println("	File saved and updated=" + updated);
				
			}
			System.out.println("<-- End of servlet " + getServletName() + ".java");
			System.out.println();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
