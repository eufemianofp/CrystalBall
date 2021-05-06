import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.rosuda.REngine.Rserve.RConnection;

@WebServlet("/Logout")
public class Logout extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("--> Entering to servlet " + getServletName() + ".java");

		// If there was no session active, there is no RConnection available, so if we
		// try
		// to shut Rserve down, we will get an error since there is no RConnection. To
		// prevent
		// this, we check the session and redirects to the index if there was no session
		// active
		if (request.getSession().getAttribute("name") == null) {
			response.sendRedirect("index.html");
			return;
		}

		System.out.println("	Shutting Rserve down.");
		RConnection c = (RConnection) request.getSession().getAttribute("RConnection");
		Rserve.shutDown(c);

		// Invalidates the session
		request.getSession().invalidate();

		// Redirects to the login page
		response.sendRedirect("index.html");

		System.out.println("<-- End of servlet " + getServletName() + ".java");
		System.out.println();

	}

}
