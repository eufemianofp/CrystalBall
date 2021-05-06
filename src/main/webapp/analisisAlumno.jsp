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
    <link href="css/custom/analisisAlumno.css" rel="stylesheet">
    
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
              <li class="active"><a href="analisisAlumno.jsp">Análisis por Alumno</a></li>
              <li><a href="analisisCurso.jsp">Análisis por Curso</a></li>
              <li><a href="actualizarDatos.jsp">Actualizar Datos</a></li>
              <li><a href="Logout">Salir</a></li>
            </ul>
          </div><!-- /.navbar-collapse -->
        </div><!-- /.container -->
      </nav>
      
      <div class="container">
        <h1>Análisis por alumno</h1>
      </div>
      
    </article>
      
    <div class="container">
      <!-- Blank space -->
      <p>&nbsp;</p>
      
      <!-- Row of contents -->
      <div class="row">
        <!-- Left side of the page -->
        <div class="col-md-4">
          <p>
            <strong>Introduzca el nº de carnet del alumno</strong>
          </p>
          
          <div class="input-group">
            <span class="input-group-addon">Alumno</span>
            <input type="text" class="form-control" id="carnet" placeholder="nº Carnet"/>
          </div>
          
          <!-- Blank space -->
          <p>&nbsp;</p>
          
          <div id="no_existe">
            <!-- Here goes a warning if the written number does not correspond to any student -->
          </div>
          
          <p>
            <strong>O búsquelo en la lista de alumnos, según el curso</strong>
          </p>
          
          <div class="input-group">
            <span class="input-group-addon">Curso</span>
            <select class="form-control">
              <!-- HERE WILL BE LOADED ALL THE COURSES AVAILABLE -->
            </select>
          </div>
          
          <!-- Blank space -->
          <p>&nbsp;</p>
          
          <!-- Student list -->
          <div class="panel panel-default">
            <div class="panel-heading">Lista de alumnos</div>
            <!-- List group -->
            <ul class="list-group">
              <br>
              <p>Aquí se mostrarán los alumnos cuando seleccione un 
                 curso o cuando busque un alumno en concreto. Haga
                 click en él para mostrar su información en el panel de
                 la derecha</p>
              <br>
            </ul>
          </div>
          <!-- /Student list -->
        </div>
        <!-- /Left side of the page -->
        
        <!-- Right side of the page -->
        <div class="col-md-8">
          <!-- Blank space -->
          <p>&nbsp;</p>
          
          <!-- Mode buttons -->
          <div class="btn-group btn-group-lg">
            <button type="button" class="btn btn-default" id="resultados">Resultados</button>
            <button type="button" class="btn btn-default" id="predicciones">Predicciones</button>
          </div>
          
          <!-- Blank space -->
          <p>&nbsp;</p>
          
          <!-- Student Panel -->
          <div class="panel panel-info">
            <div class="panel-heading">
              <h3 class="panel-title" id="carnetPanel">
                <strong>Alumno</strong>
              </h3>
            </div>
            <div class="panel-body">
              <!-- STUDENTS' GRADES WILL BE SHOWN HERE -->
              <p>Aquí se mostrarán los datos de un alumno cuando clique su link en la lista de alumnos.</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
            </div>
          </div>
  
        </div>
        <!-- /Right side of the page -->
        
      </div>
      <!-- /Row of contents -->
      
    </div>
    <!-- /container -->
  
  
    <!-- Bootstrap core JavaScript
      	================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
  
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery-1.11.1.min.js"></script>
    
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.js"></script>
    
    <script src="js/analisisAlumno.js"></script>
    
    <script>
      $("div .input-group").ready(function(){
        $("#carnet").focus();
      });
    </script>
    
  </body>
</html>