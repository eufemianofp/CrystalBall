<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% if(session.getAttribute("name")==null) response.sendRedirect("index.html"); %>

<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="Eufemiano Fuentes Pérez">
		
    <title>CrystalBall</title>
    <link rel="shortcut icon" href="img/crystalball-icon.png">

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap/bootstrap.css" rel="stylesheet">
	
    <!-- Style for the navbar -->
    <link href="css/bootstrap/justified-nav.css" rel="stylesheet">
    <link href="css/bootstrap/navbar.css" rel="stylesheet">
    
    <!-- Custom styles for this page -->
    <link href="css/custom/actualizarDatos.css" rel="stylesheet">
    
    <!-- Styles needed for alertify alerts in javascript -->
	<link href="css/alertify/alertify.core.css" rel="stylesheet">
    <link href="css/alertify/alertify.default.css" rel="stylesheet">
    <link href="css/alertify/alertify.bootstrap.css" rel="stylesheet">
    
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  
  
  <body>
  
    <article class="landing">
      <nav class="navbar navbar-default" role="navigation">
        <div class="container">
          <!-- Brand and toggle get grouped for better mobile display -->
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="menu.jsp">CrystalBall</a>
          </div>
      
          <!-- Collect the nav links, forms, and other content for toggling -->
          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right">
              <li><a href="menu.jsp">Inicio</a></li>
              <li><a href="analisisAlumno.jsp">Análisis por Alumno</a></li>
              <li><a href="analisisCurso.jsp">Análisis por Curso</a></li>
              <li class="active"><a href="actualizarDatos.jsp">Actualizar Datos</a></li>
              <li><a href="Logout">Salir</a></li>
            </ul>
          </div><!-- /.navbar-collapse -->
        </div><!-- /.container -->
      </nav>
      
      <div class="container">
        <h1>Actualizar Datos</h1>
      </div>
      
    </article>
      
      
    <div class="container">
      <!-- Blank space -->
      <p>&nbsp;</p>
      
      <!-- Row of contents -->
      <div class="row">
        <div class="col-md-5">
          
          <h3>Subir PEQs o Parciales</h3>
          
          <!-- Blank space -->
          <br>
          
          <p>Suba las notas que los alumnos van sacando durante el curso, en un <strong>archivo de MS Excel con un 
          formato predefinido</strong>, con el numero de carnet en la primera columna, y las notas que quiera 
          subir en las siguientes columnas.</p>
          
          <form action="DownloadFile" method="post">
            Descargar plantilla de notas: 
            <button type="submit" class="btn btn-default btn-lg">
              <span class="glyphicon glyphicon-download-alt"></span> Descargar
            </button>
          </form>
          
          <br>
          <p>
          Si ya ha subido algunas notas, la plantilla se descargará con las notas subidas anteriormente.
          Si quiere subir más notas, adjunte la plantilla con las nuevas notas. El nombre del archivo  
          no pueden llevar tildes.</p>
          
          <form action="UploadFile" method="post" class="upload" enctype="multipart/form-data">
            <input type="hidden" name="parciales" />
            <p><strong>Notas parciales:</strong></p>
            <input type="file" name="notas_parciales" id="notas_parciales" /><br>
            
            <p>Subir las notas parciales puede tardar unos 10 segundos.</p>
            <!-- Upload button -->
            <button type="submit" class="btn btn-default btn-lg">
              <span class="glyphicon glyphicon-upload"></span> Subir
            </button>
          </form>         
          
        </div><!-- End of 1st column -->
        
        <div class="col-md-4">
          <h3>Subir Notas Finales</h3>
          
          <!-- Blank space -->
          <br>
          
          <p>Adjunte el Excel que le proporciona TECNUN a final de curso, con todas las notas finales de los alumnos. 
             Adjunte también los exámenes de admisión anticipada y ordinaria, en formato csv. Los nombres de los 
             archivos no pueden llevar tildes y los nombres de los archivos csv con las admisiones deben empezar por "Ltdo".</p>
          
          <form action="UploadFile" method="post" class="upload" enctype="multipart/form-data">
            <input type="hidden" name="finales" />
            
            <p><strong>Notas finales</strong>, en formato MS Excel:</p>
            <input type="file" name="notas_finales" id="notas_finales" /><br>
            
            <p><strong>Exámenes de admisión</strong> del curso actual, en formato csv:</p>
            <p>Listado de admisiones en convocatoria anticipada:</p>
            <input type="file" name="admision_anticipada" id="admision_anticipada" /><br>
            <p>Listado de admisiones en convocatoria ordinaria:</p>
            <input type="file" name="admision_ordinaria" id="admision_ordinaria" /><br>
            
            <p>Subir las notas finales puede tardar 15-20 segundos.</p>
            <!-- Upload button -->
            <button type="submit" class="btn btn-default btn-lg">
              <span class="glyphicon glyphicon-upload"></span> Subir
            </button>
          </form>
          
          <!-- Blank space -->
          <p>&nbsp;</p>
          
        </div><!-- End of 2nd column -->
        
        <div class="col-md-3">
          <br>
          <!-- CURRENT STATE -->
          <div class="panel panel-info">
            <div class="panel-heading">
              <h3 class="panel-title"><strong>Estado actual</strong></h3>
            </div>
            <div class="panel-body" id="state">
              <!-- HERE GOES THE RESPONSE FROM THE SERVER CONNECTIONTORSERVE, WHICH RETRIEVES THE STATE OF THE UPLOADS -->
            </div>
          </div>
        </div><!-- End of state column -->
        
      </div><!-- End of row of contents -->
      
      <!-- Blank spaces on the bottom of the page -->
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      
    </div><!-- /container -->
		
		
	<!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery-1.11.1.min.js"></script>
    
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.js"></script>
    
    <script src="js/actualizarDatos.js"></script>
    <script src="js/alertify.min.js"></script>
		
  </body>
</html>