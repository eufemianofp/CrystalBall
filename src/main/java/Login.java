import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.rosuda.REngine.Rserve.RConnection;

@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Connection connection;

	public void init(ServletConfig config) throws ServletException {

		super.init(config);

		System.out.println("--> Entering to servlet " + getServletName() + ".java");

		// Sets the working directory
		String current_wd = getServletContext().getRealPath("").replace("\\", "/");
		AuxiliaryFunctions.setWD(current_wd);
		System.out.println("	Current wd: " + current_wd);

		// Establishes the connection to the database
		try {
			connection = AuxiliaryFunctions.connectToDB();
			System.out.println("	The servlet " + getServletName() + ".java has connected to the database.");
			System.out.println();
		} catch (Exception ex) {
			System.out.println("	The servlet " + getServletName() + ".java couldn't connect to the database.");
			System.out.println();
			ex.printStackTrace();
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("	--> doPost method of " + getServletName() + ".java");

		// Receives the user and the password
		String user = request.getParameter("user");
		String password = request.getParameter("password");

		// PreparedStatement allows to precompile SQL queries to the database
		PreparedStatement prepStatement = null;

		// Defines the query, i.e. checking the user and the password
		String SQL = "SELECT cUser, Password FROM Users WHERE cUser=? AND Password=?";
		try {
			// With this sentences we also prevent from SQL injections
			prepStatement = connection.prepareStatement(SQL);
			prepStatement.setString(1, user);
			prepStatement.setString(2, password);
		} catch (SQLException e) {
			System.out.println("	An error ocurred while trying to make a statement to the database.");
			System.out.println();
			e.printStackTrace();
		}

		// ResultSet gets the result of the SQL query
		ResultSet rs = null;
		boolean exists = false; // this variable will turn true if the user exists in the
								// database and the password is correct, otherwise it keeps being false
		try {
			rs = prepStatement.executeQuery();
			try {
				exists = rs.next();
			} catch (SQLException e) {
				System.out.println("	Either the user or the password or both are incorrect.");
				System.out.println();
			}
		} catch (SQLException e) {
			System.out.println("	An error ocurred during the query to the database.");
			System.out.println();
			e.printStackTrace();
		}

		if (exists) { // if the user exists in the database

			// Starts Rserve up and connects to it
			RConnection c = Rserve.startUpAndConnect();

			// Stores the RConnection in the user's session
			request.getSession().setAttribute("name", user);
			request.getSession().setAttribute("RConnection", c);

			// Calls the servlet that prints the main menu
			response.sendRedirect("menu.jsp");

			System.out.println("<-- End of servlet " + getServletName() + ".java");
			System.out.println();

		} else { // if the user or the password were invalid

			// Sends the user to the landing page
			response.sendRedirect("invalidUser.html");

			System.out.println("	Invalid user or password.");
			System.out.println("<-- End of servlet " + getServletName() + ".java");
			System.out.println();
		}
	}

	public void destroy() {
		super.destroy();
		try {
			connection.close();
			System.out.println(
					"	-->The servlet " + getServletName() + ".java has closed the connection to the database.");
			System.out.println();
		} catch (SQLException ex) {
			System.out.println(
					"	-->The servlet " + getServletName() + ".java couldn't close the connection to the database.");
			System.out.println();
			ex.printStackTrace();
		}
	}

}
