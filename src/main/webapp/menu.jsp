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
    <link href="css/custom/menu.css" rel="stylesheet">
    
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
              <li class="active"><a href="menu.jsp">Inicio</a></li>
              <li><a href="analisisAlumno.jsp">Análisis por Alumno</a></li>
              <li><a href="analisisCurso.jsp">Análisis por Curso</a></li>
              <li><a href="actualizarDatos.jsp">Actualizar Datos</a></li>
              <li><a href="Logout">Salir</a></li>
            </ul>
          </div><!-- /.navbar-collapse -->
        </div><!-- /.container -->
      </nav>
      
      <div class="container">
        <!-- Jumbotron -->
        <div class="jumbotron">
          <h1>¡Bienvenido a CrystalBall!</h1>
          <p class="lead">CrystalBall es una herramienta de asistencia
            al asesor, con la que podrá realizar un mejor seguimiento y
            asesoramiento académico a sus asesorados.</p>
        </div>
      </div>
      
    </article>
      
    
    <div class="container">
      
      <!-- Row of columns -->
      <div class="row">
        <div class="col-md-4">
          <a href="analisisAlumno.jsp">
            <img src="img/alumno.png" alt="Análisis por Alumno" class="img-circle">
          </a>
          <h2>Análisis por Alumno</h2>
          <p>
            El análisis por alumno permite un <strong>seguimiento</strong>
            de las notas que va obteniendo el alumno durante el curso, y
            hace una <strong>predicción</strong> de las notas finales en
            base a esas notas.
          </p>
        </div>
        <div class="col-md-4">
          <a href="analisisCurso.jsp">
            <img src="img/curso.png" alt="Análisis por Curso" class="img-circle">
          </a>
          <h2>Análisis por Curso</h2>
          <p>
            El análisis por curso permite ver la <strong>situación
              general del curso</strong> en cada asignatura. También permite
            <strong>generar gráficas e informes</strong> del curso entero.
          </p>
        </div>
        <div class="col-md-4">
          <a href="actualizarDatos.jsp">
            <img src="img/updates.jpg" alt="Actualizar Datos" class="img-circle">
          </a>
          <h2>Actualizar Datos</h2>
          <p>
            Esta sección permite <strong>incorporar las notas</strong> que
            vayan obteniendo los alumnos durante el curso (parciales) <strong>a
              la base de datos</strong>. También permite actualizar al final del
            curso todas las notas finales, las que da TECNUN.
          </p>
        </div>
      </div>
      
      <!-- Blank spaces on the bottom of the page -->
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      
    </div>
    <!-- /container -->
    
    <!-- Bootstrap core JavaScript
        ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
  
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery-1.11.1.min.js"></script>
    
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.js"></script>
  
  </body>
</html>