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
    <link href="css/custom/analisisCurso.css" rel="stylesheet">
    
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
              <li class="active"><a href="analisisCurso.jsp">Análisis por Curso</a></li>
              <li><a href="actualizarDatos.jsp">Actualizar Datos</a></li>
              <li><a href="Logout">Salir</a></li>
            </ul>
          </div><!-- /.navbar-collapse -->
        </div><!-- /.container -->
      </nav>
      
      <div class="container">
        <h1>Análisis por Curso</h1>
      </div>
      
    </article>
      
    <div class="container">
      <!-- Blank space -->
      <p>&nbsp;</p>
      
      <!-- Row of contents -->
      <div class="row">
      
        <div class="col-md-7">
          
          <h3>Informes</h3>
          
          <!-- Blank space -->
          <br>
          
          <div class="panel-group" id="accordion">
            <div class="panel panel-default">
              <a data-toggle="collapse" data-parent="#accordion" id="informesGuardados" href="#informesAnteriores">
                <div class="panel-heading">
                  <h4 class="panel-title">
                      Informes guardados
                  </h4>
                </div>
              </a>
              <div id="informesAnteriores" class="panel-collapse collapse in">
                <div class="panel-body">
                  
                  <div class="list-group">
                    <!-- HERE WILL LOAD THE REPORTS SAVED BY THE USER -->
                  </div><!-- /.list-group -->
                  
                </div>
              </div>
            </div>
            <div class="panel panel-default new-graph">
              <a data-toggle="collapse" data-parent="#accordion" id="newReport" href="#NuevoInforme">
                <div class="panel-heading">
                  <h4 class="panel-title">
                      Nuevo informe
                  </h4>
                </div>
              </a>
              <div id="NuevoInforme" class="panel-collapse collapse">
                <div class="panel-body">
                    
                  <div class="row">
                    <div class="col-md-7">
                      <div class="input-group">
                        <span class="input-group-addon">Gráfico</span>
                        <select class="form-control" id="graphs-newReport">
                          <option>Boxplot</option>
                          <option>Boxplot según titulación</option>
                          <option>Predicción vs Resultados</option>
                          <option>Tabla con calificaciones</option>
                        </select>
                      </div>
                    </div>
                  </div>
                  
                  <div class="row">
                    <div class="col-md-7">
                      <div class="input-group">
                        <span class="input-group-addon">Asignatura</span>
                        <select class="form-control" id="subjects-newReport">
                          <option class="1C">Primer cuatrimestre</option>
                          <option class="2C">Segundo cuatrimestre</option>
                          <option>Matemáticas</option>
                          <option>Física</option>
                          <option>Informática</option>
                          <option>Antropología</option>
                          <option>ECC</option>
                          <option>Matemáticas II</option>
                          <option>Física II</option>
                          <option>Estadística y Probabilidad</option>
                          <option>Economía y Empresa</option>
                          <option>Antropología II</option>
                          <option>ECC II</option>
                        </select>
                      </div>
                    </div>
                    
                    <div class="col-md-5">
                      <div class="input-group">
                        <span class="input-group-addon">Curso</span>
                        <select class="form-control" id="years-newReport">
                          <!-- HERE WILL BE LOADED ALL THE COURSES AVAILABLE -->
                        </select>
                      </div>
                    </div>
                  </div>
                  
                  
                  <div class="row">
                    <div class="col-md-12">
                      <div class="input-group">
                        <span class="input-group-addon">Título</span>
                        <input type="text" class="form-control" id="graph_title-newReport" placeholder="Título del gráfico"/>
                      </div>
                    </div>
                  </div>
                  
                  <div class="row">
                    <div class="col-md-12">
                      <div class="input-group">
                        <span class="input-group-addon">Comentario</span>
                        <textarea class="form-control" id="comment-newReport" rows="2" placeholder="Comentario acerca del gráfico"></textarea>
                      </div>
                    </div>
                  </div>
                  
                  
                  <div class="row">
                    <div class="col-md-4">
                      <button class="btn btn-default btn-lg" id="add-graph-newReport">
                        <span class="glyphicon glyphicon-plus-sign"></span> Añadir al informe
                      </button>
                    </div>
                  </div>
                  
                </div><!-- /.panel-body -->
              </div><!-- /.panel-collapse -->
            </div><!-- /.panel -->
          
          </div><!-- /.panel-group -->
          
        </div><!-- /.col-md-7 -->
        
        <div class="col-md-1">
        </div>
        
        <div class="col-md-4">
          <br>
          <!-- CURRENT STATE -->
          <div class="panel panel-info">
            <div class="panel-heading">
              <h3 class="panel-title"><strong>Mi Informe</strong></h3>
            </div>
            <div class="panel-body" id="report">
              
              <div class="form-group">
                <label class="control-label" for="report_title">Título del informe:</label>
                <input type="text" class="form-control" id="report_title" placeholder="Título del informe" />
              </div>
              
              <p><strong>Gráficos añadidos:</strong></p>
              <div id="addedGraphs">
                <p style="margin-left:10px;">No hay gráficos añadidos al informe</p>
                <!-- HERE WILL BE ADDED THE GRAPHS BY THE USER -->
              </div>
              
              <button class="btn btn-default btn-lg" id="generateReport">
                <span class="glyphicon glyphicon-plus-sign"></span> Generar informe
              </button>
              
            </div>
          </div>
          
        </div>
        
      </div><!-- End of row of contents -->
      <!-- Blank space -->
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
    
    <script src="js/analisisCurso.js"></script>
    <script src="js/alertify.min.js"></script>
		
  </body>
</html>