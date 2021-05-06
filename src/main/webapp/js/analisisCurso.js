$(document).ready(function(){
	
	addGraphListener();
	generateReport();
	getCurrentYear();
	loadReports();
	loadYears();
	modifyReport();
	newReport();
	onEnterPress();
	openReport();
	removeReport();
	selectGraph();
	selectReport();
	semester1Uploaded();
});

// Variable to know the current academic year
var currentYear;

// Variable to know if the grades from the 1 semester were uploaded
var semester1Uploaded;

// Variable to know if the showed report is new or loaded
var reportLoaded = false;

// Variables of a report when it is created
var graphs = [];
var subjects = [];
var years = [];
var titles = [];
var comments = [];

// Variables of existing reports
var cReports = [];
var reportNames = [];
var reportPaths = [];
var loadedGraphs = []; // This is set to 2 dim array
var loadedSubjects = []; // This is set to 2 dim array
var loadedYears = []; // This is set to 2 dim array
var loadedTitles = []; // This is set to 2 dim array
var loadedComments = []; // This is set to 2 dim array

// Variables of current selected report
var reportName;
var reportGraphs = [];
var reportSubjects = [];
var reportYears = [];
var reportGraph_titles = [];
var reportComments = [];

function addGraphSavedReport(){
	
	var graph = $("#graphs-savedReport").val();
	var subject = $("#subjects-savedReport").val();
	var year = $("#years-savedReport").val();
	var graph_title = $("#graph_title-savedReport").val();
	var comment = $("#comment-savedReport").val();
	
	if(year == "-- Elija un curso --"){
		alertify.alert("Debe elegir un curso antes de a&ntilde;adir el gr&aacute;fico.");
		return;
	}
	if(graph_title == ""){
		alertify.alert("Debe poner un t&iacute;tulo al gr&aacute;fico.");
		return;
	}
	
	if(graphs.length == 0) $("#addedGraphs").html("");
	
	var currentGraphs = $("#addedGraphs").html();
	
	var newGraph = "<div class='panel-group' id='grafico_" + graphs.length + "'>";
	newGraph += "<div class='panel panel-default'>";
	newGraph += "<a data-toggle='collapse' data-parent='#addedGraphs' href='#grafico" + graphs.length + "'>";
	newGraph += "<div class='panel-heading'>";
	newGraph += "<h4 class='panel-title'>" + graph_title + "</h4>";
	newGraph += "</div></a>";
	newGraph += "<div id='grafico" + graphs.length + "' class='panel-collapse collapse'>";
	newGraph += "<div class='panel-body'>";
	newGraph += "<p><u>Tipo de gr&aacute;fico</u>: " + graph + "</p>";
	newGraph += "<p><u>Asignatura</u>: " + subject + "</p>";
	newGraph += "<p><u>Curso</u>: " + year + "</p>";
	newGraph += "<p><u>Comentario</u>: " + comment + "</p>";
	newGraph += "<button class='btn btn-danger btn-sm' onclick='removeGraph(" + graphs.length + ")'>";
    newGraph += "<span class='glyphicon glyphicon-remove'></span> Eliminar";
    newGraph += "</button>";
	newGraph += "</div></div></div></div>";
	
	$("#addedGraphs").html(currentGraphs + newGraph);
	
	$("#graph_title-savedReport").val("");
	$("#comment-savedReport").val("");
	
	reportGraphs[reportGraphs.length] = graph;
	reportSubjects[reportSubjects.length] = subject;
	reportYears[reportYears.length] = year;
	reportGraph_titles[reportGraph_titles.length] = graph_title;
	reportComments[reportComments.length] = comment;
}

function addGraphNewReport(){
	
	var graph = $("#graphs-newReport").val();
	var subject = $("#subjects-newReport").val();
	var year = $("#years-newReport").val();
	var graph_title = $("#graph_title-newReport").val();
	var comment = $("#comment-newReport").val();
	
	if(year == "-- Elija un curso --"){
		alertify.alert("Debe elegir un curso antes de a&ntilde;adir el gr&aacute;fico.");
		return;
	}
	if(graph_title == ""){
		alertify.alert("Debe poner un t&iacute;tulo al gr&aacute;fico.");
		return;
	}
	
	if(graphs.length == 0) $("#addedGraphs").html("");
	
	var currentGraphs = $("#addedGraphs").html();
	
	var newGraph = "<div class='panel-group' id='grafico_" + graphs.length + "'>";
	newGraph += "<div class='panel panel-default'>";
	newGraph += "<a data-toggle='collapse' data-parent='#addedGraphs' href='#grafico" + graphs.length + "'>";
	newGraph += "<div class='panel-heading'>";
	newGraph += "<h4 class='panel-title'>" + graph_title + "</h4>";
	newGraph += "</div></a>";
	newGraph += "<div id='grafico" + graphs.length + "' class='panel-collapse collapse'>";
	newGraph += "<div class='panel-body'>";
	newGraph += "<p><u>Tipo de gr&aacute;fico</u>: " + graph + "</p>";
	newGraph += "<p><u>Asignatura</u>: " + subject + "</p>";
	newGraph += "<p><u>Curso</u>: " + year + "</p>";
	newGraph += "<p><u>Comentario</u>: " + comment + "</p>";
	newGraph += "<button class='btn btn-danger btn-sm' onclick='removeGraph(" + graphs.length + ")'>";
    newGraph += "<span class='glyphicon glyphicon-remove'></span> Eliminar";
    newGraph += "</button>";
	newGraph += "</div></div></div></div>";
	
	$("#addedGraphs").html(currentGraphs + newGraph);
	
	$("#graph_title-newReport").val("");
	$("#comment-newReport").val("");
	
	graphs[graphs.length] = graph;
	subjects[subjects.length] = subject;
	years[years.length] = year;
	titles[titles.length] = graph_title;
	comments[comments.length] = comment;
	
}

function addGraphListener(){
	
	$("#add-graph-newReport").on("click", function(e){
		addGraphNewReport();
	});
	
	$("#informesAnteriores .panel-body").on("click", "#add-graph-savedReport", function(e){
		addGraphSavedReport();
	});
}

function generateReport(){
	
	$("#report").on("click", "#generateReport", function(){
		
		var report_title = $("#report_title").val();
		var length = graphs.length;
		
		if (length == 0) {
			alertify.alert("Primero debe a&ntilde;adir un gr&aacute;fico al informe.");
			return;
		} else if(report_title == "") {
			alertify.alert("Debe poner un nombre a su informe antes de generarlo.");
			return;
		} else if (/^[a-zA-Z0-9-_ ]*$/.test(report_title) == false){ // Letras de la a-z, A-Z, 0-9, -, _ y espacio
			alertify.alert("El t&iacute;tulo no puede contener caracteres especiales (tildes, \"&ntilde;\", ...)");
		}
		
		// Parses the arrays to JSON array format
		var JSONgraphs = JSON.stringify(graphs);
		var JSONsubjects = JSON.stringify(subjects);
		var JSONyears = JSON.stringify(years);
		var JSONtitles = JSON.stringify(titles);
		var JSONcomments = JSON.stringify(comments);
		
		$.post("ConnectionToRserve",
			{
				option: "generateReport",
				report_title: report_title,
				graphs: JSONgraphs,
				subjects: JSONsubjects,
				years: JSONyears,
				titles: JSONtitles,
				comments: JSONcomments
			},
			function(data){
				// alertify.alert("data.success: " + data.success + ". Type of data.success: " + typeof(data.success));
				if (data.success == true) {
					// Resets the graphs
					graphs = new Array();
					subjects = new Array();
					years = new Array();
					titles = new Array();
					comments = new Array();
					
					$("#informesGuardados").on("click", function(){
						loadReports();
					});
					
					alertify.set({ buttonReverse: true });
					alertify.set({ labels: {
					    ok     : "Ver informe",
					    cancel : "Ahora no"
					}});
					window.setTimeout(function(){
						alertify.confirm("Informe generado correctamente. &iquest;Desea ver el informe ahora?", function(e){
						    if(e) window.open(data.reportPath, "_blank");
						});
					}, 1000); // Waits 1 second in order to be able to show the report
					
					alertify.set({ labels: {
					    ok     : "Ok",
					    cancel : "Cancelar"
					}});
					
					resetReport();
					
				} else {
					alertify.alert("Ha habido un problema al generar el informe. Int&eacute;ntelo en otra ocasi&oacute;n.");
				}
			});
	});
}

function getCurrentYear(){
	
	$.post("ConnectionToRserve",
			{
				option: "getCurrentYear"
			},
			function(data){
				currentYear = data.currentYear;
			});
}

function loadReports(){
	
	// LOADS ALL THE REPORTS THAT HAVE BEEN SAVED
	$.post("ConnectionToRserve", 
		{
			option: "loadReports",
		},
		function(data){
			
			var reports = "";
			
			// Resets the values of the loaded reports
			cReports = [];
			reportNames = [];
			reportPaths = [];
			loadedGraphs = [];
			loadedSubjects = [];
			loadedYears = [];
			loadedTitles = [];
			loadedComments = [];
			
			for(var i=0; i<data.length; i++){
				
				cReports[i] = data[i].cReport;
				reportNames[i] = data[i].report_title;
				reportPaths[i] = data[i].reportPath;
				
				reports += "<a href='#' class='list-group-item' id='report_" + cReports[i] + "' cReport='" + cReports[i] + "' path='" + reportPaths[i] + "'><span>" + reportNames[i] + "</span><span class='badge remove'>Eliminar</span><span class='badge openReport'>Ver informe</span></a>";
				
				var tempGraphs = [];
				var tempSubjects = [];
				var tempYears = [];
				var tempTitles = [];
				var tempComments = [];
				
				for(var j=0; j<data[i].graphs.subjects.length; j++){
					
					tempGraphs[j] = data[i].graphs.types[j];
					tempSubjects[j] =  data[i].graphs.subjects[j];
					tempYears[j] = data[i].graphs.years[j];
					tempTitles[j] = data[i].graphs.titles[j];
					tempComments[j] = data[i].graphs.comments[j];
				}
				loadedGraphs.push(tempGraphs);
				loadedSubjects.push(tempSubjects);
				loadedYears.push(tempYears);
				loadedTitles.push(tempTitles);
				loadedComments.push(tempComments);
			}
			$("#informesAnteriores .list-group .list-group-item").remove();
			$(".list-group").html(reports);
		});
}

function loadYears(){
	
	// LOADS ALL THE ACADEMIC YEARS WITH RECORDS
	$.post("ConnectionToRserve", 
		{
			option: "cargarCursos",
			currentYear: false
		},
		function(data){
			$("#years-newReport").html(data);
			$("#years-savedReport").html(data);
		});
}

function modifyReport(){
	
	$("#report").on("click", "#modifyReport", function(){
		
		var report_title = $("#report_title").val();
		var cReport = $(this).attr("cReport");
		
		if(report_title == ""){
			alertify.alert("Debe poner un nombre a su informe antes de generarlo.");
			return;
		}
		
		var JSONreportGraphs = JSON.stringify(reportGraphs);
		var JSONreportSubjects = JSON.stringify(reportSubjects);
		var JSONreportYears = JSON.stringify(reportYears);
		var JSONreportGraph_titles = JSON.stringify(reportGraph_titles);
		var JSONreportComments = JSON.stringify(reportComments);
		
		$.post("ConnectionToRserve",
			{
				option: "modifyReport",
				cReport: cReport,
				report_title: report_title,
				graphs: JSONreportGraphs,
				subjects: JSONreportSubjects,
				years: JSONreportYears,
				titles: JSONreportGraph_titles,
				comments: JSONreportComments
			},
			function(data){
				// alertify.alert("data.success: " + data.success + ". Type of data.success: " + typeof(data.success));
				if (data.success == true) {
					loadReports();
					alertify.alert("Informe guardado con &eacute;xito");
				} else {
					alertify.alert("Ha habido un problema al guardar el informe. Int&eacute;ntelo en otra ocasi&oacute;n.");
				}
			});
	});
}

function newReport(){
	
	$("#newReport").on("click", function(){

		resetReport();
	});
}

function onEnterPress(){
	
	// New report graphs
	$("#graph_title-savedReport").keypress(function(key){
		if(key.which == 13) addGraphSavedReport();
	});
	
	$("#comment-savedReport").keypress(function(key){
		if(key.which == 13) addGraphSavedReport();
	});
	
	// Saved report new graph
	$("#graph_title-newReport").keypress(function(key){
		if(key.which == 13) addGraphNewReport();
	});
	
	$("#comment-newReport").keypress(function(key){
		if(key.which == 13) addGraphNewReport();
	});
}

function openReport(){
	
	$("#informesAnteriores .panel-body").on("click", ".badge.openReport", function(){
		var path = $(this).parent().attr("path");
		window.open(path, "_blank");
	});
}

function removeGraph(i){
	
	// Removes the graph
	var graph = "#grafico_" + i;
	$(graph).remove();
	
	// Removes the graph's parameters from the saved graphs
	graphs.splice(i, 1);
	subjects.splice(i, 1);
	years.splice(i, 1);
	titles.splice(i, 1);
	comments.splice(i, 1);
	
	// If there are no graphs, attachs the following text to the report
	if(graphs.length == 0){
		$("#addedGraphs").html("<p style='margin-left:10px;'>No hay gr&aacute;ficos a&ntilde;adidos al informe</p>");
	}
}

function removeGraphSavedReport(i){
	
	// Removes the graph
	var graph = "#grafico_" + i;
	$(graph).remove();
	
	// Removes the graph's parameters from the saved graphs
	reportGraphs.splice(i, 1);
	reportSubjects.splice(i, 1);
	reportYears.splice(i, 1);
	reportGraph_titles.splice(i, 1);
	reportComments.splice(i, 1);
	
	// If there are no graphs, attachs the following text to the report
	if(reportGraphs.length == 0){
		$("#addedGraphs").html("<p style='margin-left:10px;'>No hay gr&aacute;ficos a&ntilde;adidos al informe</p>");
	}
	
}

function removeReport(){
	
	$("#informesAnteriores .panel-body").on("click", ".badge.remove", function(){
		
		var report_title = $(this).prev().text();
		var report = $(this).parent();
		
		alertify.set({ buttonReverse: true });
		alertify.set({ labels: {
		    ok     : "Eliminar",
		    cancel : "Cancelar"
		}});
		var message = "&iquest;Seguro que desea eliminar el informe \"" + report_title + "\"?";
		alertify.confirm(message, function(e){
			if(e){
				var cReport = report.attr("cReport");
				
				// REMOVES THE SELECTED REPORT
				$.post("ConnectionToRserve", 
					{
						option: "removeReport",
						cReport: cReport
					},
					function(data){
						// alertify.alert("data.success: " + data.success + ". Type of data.success: " + typeof(data.success));
						if (data.success == "true") {
							report.remove();
							resetReport();
							var report_id = "#report_" + cReport;
							$(report_id).remove();
							alertify.set({ labels: {
							    ok     : "OK",
							    cancel : "Cancelar"
							}});
							alertify.alert("El informe \"" + report_title + "\" se ha eliminado correctamente.");
						} else { 
							alertify.alert("Ha habido un problema al intentar eliminar el informe \"" + report_title + "\. " +
											 "Int&eacute;ntelo en otra ocasi&oacute;n.");
						}
						
					});
			}
		});
	});
}

function resetReport(){
	
	var reportText = "<div class='form-group'>";
	reportText += "<label class='control-label' for='report_title'>T&iacute;tulo del informe:</label>";
	reportText += "<input type='text' class='form-control' id='report_title' placeholder='T&iacute;tulo del informe' />";
	reportText += "</div>";
	reportText += "<p><strong>Gr&aacute;ficos a&ntilde;adidos:</strong></p>";
	reportText += "<div id='addedGraphs'>";
	reportText += "<p style='margin-left:10px;'>No hay gr&aacute;ficos a&ntilde;adidos al informe</p>";
	reportText += "</div>";
	reportText += "<button class='btn btn-default btn-lg' id='generateReport'>";
	reportText += "<span class='glyphicon glyphicon-plus-sign'></span> Generar informe";
	reportText += "</button>";
	
	$("#report").html(reportText);
	
}

function selectGraph(){
	
	/*
	 * 	CHANGING THE TYPE OF GRAPH IN A NEW REPORT
	 */
	$(document).on("change", "#graphs-newReport", function(){
		
		var selected = $(this).val();
		
		/*
		 * 	BOXPLOT
		 */
		if(selected.search("Boxplot") == 0 && selected.length == 7){
			var subjects = $("#subjects-newReport").html();
			var newOptions = "<option class='1C'>Primer cuatrimestre</option>";
			newOptions += "<option class='2C'>Segundo cuatrimestre</option>";
			$("#subjects-newReport").html(newOptions + subjects);
		}else{
			$("option.1C").remove();
			$("option.2C").remove();
		}
		
		/*
		 * 	BOXPLOT SEG�N TITULACI�N
		 */
		if(selected.search("titulaci") != -1){
			var years = $("#years-newReport").html();
			var newOption = "<option class='TodosCursos'>Todos los cursos</option>";
			$("#years-newReport").html(years + newOption);
		}else $(".TodosCursos").remove();
		
		/*
		 * 	PREDICCIONES VS RESULTADOS
		 */
		if(selected.search("Predicci") != -1){
			
			for(var i=6; i<=11; i++){
				$("#subjects-newReport option:nth-child(" + i + ")").attr("disabled", "disabled");
			}
			
			if(currentYear == "2013-2014" && !semester1Uploaded){
				$("#subjects-newReport").attr("disabled", "disabled");
				$("#years-newReport").attr("disabled", "disabled");
				$("#graph_title-newReport").attr("disabled", "disabled");
				$("#comment-newReport").attr("disabled", "disabled");
				$("#add-graph-newReport").attr("disabled", "disabled");
				alertify.alert("No se puede generar este tipo de gr&aacute;fico hasta que no se tengan al menos " +
								"las notas del primer cuatrimestre del curso 2013-2014.");
			}else if(!semester1Uploaded){
				// Handling years permitted
				$("#years-newReport option:nth-child(2)").attr("disabled", "disabled");//2012-2013 banned
				var years = $("#years-newReport").html();
				var thisYear = "<option class='currentYear' disabled>" + currentYear + "</option>";
				$("#years-newReport").html(years + thisYear);
				
				// All subjects permitted from past years
				$("#subjects-newReport option").removeAttr("disabled");
			}else{
				// Handling years permitted
				$("#years-newReport option:nth-child(2)").attr("disabled", "disabled");//2012-2013 banned
				var years = $("#years-newReport").html();
				var thisYear = "<option class='currentYear'>" + currentYear + "</option>";
				$("#years-newReport").html(years + thisYear);
				
				// Handling subjects permitted
				$("#years-newReport").on("change", function(){
					
					var yearSelected = $(this).val();
					
					// If the year selected is the current year, we have to ban the subjects from semester 2
					if(yearSelected == currentYear){
						for(var i=6; i<=11; i++){
							$("#subjects-newReport option:nth-child(" + i + ")").attr("disabled", "disabled");
						}
					// If the year selected is whichever different from the current, we permit all subjects	
					}else $("#subjects-newReport option").removeAttr("disabled");
				});
			}
		}else{
			// Removes current year
			$("#years-newReport option.currentYear").remove();
			// Enables all the years
			$("#years-newReport option").removeAttr("disabled");
			// Enables all the subjects
			$("#subjects-newReport option").removeAttr("disabled");
			
			// This is just in case currentYear=="2013-2014" and semester1Upload==false
			$("#subjects-newReport").removeAttr("disabled");
			$("#years-newReport").removeAttr("disabled");
			$("#graph_title-newReport").removeAttr("disabled");
			$("#comment-newReport").removeAttr("disabled");
			$("#add-graph-newReport").removeAttr("disabled");
		}
		
		/*
		 * 	TABLA CON CALIFICACIONES
		 */
		if(selected == "Tabla con calificaciones"){
			var subjects = $("#subjects-newReport").html();
			var years = $("#years-newReport").html();
			
			var newSubject = "<option class='Todas'>Todas</option>";
			var newYear = "<option class='Todos'>Todos los cursos</option>";
			
			$("#subjects-newReport").html(newSubject + subjects);
			$("#years-newReport").html(years + newYear);
			
			$("#subjects-newReport").attr("disabled", "disabled");
		}else{
			$(".Todas").remove();
			$(".Todos").remove();
			$("#subjects-newReport").removeAttr("disabled");
		}
	});
	
	/*
	 * 	CHANGING THE TYPE OF GRAPH TO A SAVED REPORT
	 */
	$(document).on("change", "#graphs-savedReport", function(){
		
		var selected = $(this).val();
		
		/*
		 * 	BOXPLOT
		 */
		if(selected.search("Boxplot") == 0 && selected.length == 7){
			var subjects = $("#subjects-savedReport").html();
			var newOptions = "<option class='1C'>Primer cuatrimestre</option>";
			newOptions += "<option class='2C'>Segundo cuatrimestre</option>";
			$("#subjects-savedReport").html(newOptions + subjects);
		}else{
			$("option.1C").remove();
			$("option.2C").remove();
		}
		
		/*
		 * 	BOXPLOT SEG�N TITULACI�N
		 */
		if(selected.search("titulaci") != -1){
			var years = $("#years-savedReport").html();
			var newOption = "<option class='TodosCursos'>Todos los cursos</option>";
			$("#years-savedReport").html(years + newOption);
		}else $(".TodosCursos").remove();
		
		/*
		 * 	PREDICCIONES VS RESULTADOS
		 */
		if(selected.search("Predicci") != -1){
			
			for(var i=6; i<=11; i++){
				$("#subjects-savedReport option:nth-child(" + i + ")").attr("disabled", "disabled");
			}
			
			if(currentYear == "2013-2014" && !semester1Uploaded){
				$("#subjects-savedReport").attr("disabled", "disabled");
				$("#years-savedReport").attr("disabled", "disabled");
				$("#graph_title-savedReport").attr("disabled", "disabled");
				$("#comment-savedReport").attr("disabled", "disabled");
				$("#add-graph-savedReport").attr("disabled", "disabled");
				alertify.alert("No se puede generar este tipo de gr&aacute;fico hasta que no se tengan al menos " +
								"las notas del primer cuatrimestre del curso 2013-2014.");
			}else if(!semester1Uploaded){
				// Handling years permitted
				$("#years-savedReport option:nth-child(2)").attr("disabled", "disabled");//2012-2013 banned
				var years = $("#years-savedReport").html();
				var thisYear = "<option class='currentYear' disabled>" + currentYear + "</option>";
				$("#years-savedReport").html(years + thisYear);
				
				// All subjects permitted from past years
				$("#subjects-savedReport option").removeAttr("disabled");
			}else{
				// Handling years permitted
				$("#years-savedReport option:nth-child(2)").attr("disabled", "disabled");//2012-2013 banned
				var years = $("#years-savedReport").html();
				var thisYear = "<option class='currentYear'>" + currentYear + "</option>";
				$("#years-savedReport").html(years + thisYear);
				
				// Handling subjects permitted
				$("#years-savedReport").on("change", function(){
					
					var yearSelected = $(this).val();
					
					// If the year selected is the current year, we have to ban the subjects from semester 2
					if(yearSelected == currentYear){
						for(var i=6; i<=11; i++){
							$("#subjects-savedReport option:nth-child(" + i + ")").attr("disabled", "disabled");
						}
					// If the year selected is whichever different from the current, we permit all subjects	
					}else $("#subjects-savedReport option").removeAttr("disabled");
				});
			}
		}else{
			// Removes current year
			$("#years-savedReport option.currentYear").remove();
			// Enables all the years
			$("#years-savedReport option").removeAttr("disabled");
			// Enables all the subjects
			$("#subjects-savedReport option").removeAttr("disabled");
			
			// This is just in case currentYear=="2013-2014" and semester1Upload==false
			$("#subjects-savedReport").removeAttr("disabled");
			$("#years-savedReport").removeAttr("disabled");
			$("#graph_title-savedReport").removeAttr("disabled");
			$("#comment-savedReport").removeAttr("disabled");
			$("#add-graph-savedReport").removeAttr("disabled");
		}
		
		/*
		 * 	TABLA CON CALIFICACIONES
		 */
		if(selected == "Tabla con calificaciones"){
			var subjects = $("#subjects-savedReport").html();
			var years = $("#years-savedReport").html();
			
			var newSubject = "<option class='Todas'>Todas</option>";
			var newYear = "<option class='Todos'>Todos los cursos</option>";
			
			$("#subjects-savedReport").html(newSubject + subjects);
			$("#years-savedReport").html(years + newYear);
			
			$("#subjects-savedReport").attr("disabled", "disabled");
		}else{
			$(".Todas").remove();
			$(".Todos").remove();
			$("#subjects-savedReport").removeAttr("disabled");
		}
	});
}

function selectReport(){
	
	$("#informesAnteriores .panel-body").on("click", ".list-group-item", function(){
		
		$(".list-group-item").removeClass("active");
		$(this).addClass("active");
		
		// Retrieves the cReport to send it to the server
		var cReport = $(this).attr("cReport");
		cReport = parseInt(cReport);
		
		// Position of the selected report in the array of reports.
		var pos = cReports.indexOf(cReport);
		
		reportName = reportNames[pos];
		reportGraphs = loadedGraphs[pos];
		reportSubjects = loadedSubjects[pos];
		reportYears = loadedYears[pos];
		reportGraph_titles = loadedTitles[pos];
		reportComments = loadedComments[pos];
		
		$("#report_title").val(reportName);
		
		var graphs_html = "";
		
		for(var i=0; i<reportGraphs.length; i++){
			graphs_html += "<div class='panel-group' id='grafico_" + i + "'>";
			graphs_html += "<div class='panel panel-default'>";
			graphs_html += "<a data-toggle='collapse' data-parent='#addedGraphs' href='#grafico" + i + "'>";
			graphs_html += "<div class='panel-heading'>";
			graphs_html += "<h4 class='panel-title'>" + reportGraph_titles[i] + "</h4>";
			graphs_html += "</div></a>";
			graphs_html += "<div id='grafico" + i + "' class='panel-collapse collapse'>";
			graphs_html += "<div class='panel-body'>";
			graphs_html += "<p><u>Tipo de gr&aacute;fico</u>: " + reportGraphs[i] + "</p>";
			graphs_html += "<p><u>Asignatura</u>: " + reportSubjects[i] + "</p>";
			graphs_html += "<p><u>Curso</u>: " + reportYears[i] + "</p>";
			graphs_html += "<p><u>Comentario</u>: " + reportComments[i] + "</p>";
			graphs_html += "<button class='btn btn-danger btn-sm' onclick='removeGraphSavedReport(" + i + ")'>";
	        graphs_html += "<span class='glyphicon glyphicon-remove'></span> Eliminar";
	        graphs_html += "</button>";
			graphs_html += "</div></div></div></div>";
		}
		$("#addedGraphs").html(graphs_html);
		$("#generateReport").attr("id", "modifyReport");
		$("#modifyReport").html("<span class='glyphicon glyphicon-floppy-save'></span> Guardar informe");
		$("#modifyReport").attr("cReport", cReport);
		
		if(!$("#newGraph").length){
			var newGraph = "<!-- Blank space -->" +
	                    "<div class='panel panel-default new-graph' id='addGraphToSavedReport'>" +
	                      "<a data-toggle='collapse' data-parent='#' id='newGraph' href='#NewGraph'>" +
	                        "<div class='panel-heading'>" +
	                          "<h4 class='panel-title'>" +
	                              "A&ntilde;adir Gr&aacute;fico" +
	                          "</h4>" +
	                        "</div>" +
	                      "</a>" +
	                      "<div id='NewGraph' class='panel-collapse collapse'>" +
	                        "<div class='panel-body'>" +
	                            
	                          "<div class='row'>" +
	                            "<div class='col-md-7'>" +
	                              "<div class='input-group'>" +
	                                "<span class='input-group-addon'>Gr&aacute;fico</span>" +
	                                "<select class='form-control' id='graphs-savedReport'>" +
	                                  "<option>Boxplot</option>" +
	                                  "<option>Boxplot seg&uacute;n titulaci&oacute;n</option>" +
	                                  "<option>Predicci&oacute;n vs Resultados</option>" +
	                                  "<option>Tabla con calificaciones</option>" +
	                                "</select>" +
	                              "</div>" +
	                            "</div>" +
	                          "</div>" +
	                          
	                          "<div class='row'>" +
	                            "<div class='col-md-7'>" +
	                              "<div class='input-group'>" +
	                                "<span class='input-group-addon'>Asignatura</span>" +
	                                "<select class='form-control' id='subjects-savedReport'>" +
	                                  "<option class='1C'>Primer cuatrimestre</option>" +
	                                  "<option class='2C'>Segundo cuatrimestre</option>" +
	                                  "<option>Matem&aacute;ticas</option>" +
	                                  "<option>F&iacute;sica</option>" +
	                                  "<option>Inform&aacute;tica</option>" +
	                                  "<option>Antropolog&iacute;a</option>" +
	                                  "<option>ECC</option>" +
	                                  "<option>Matem&aacute;ticas II</option>" +
	                                  "<option>F&iacute;sica II</option>" +
	                                  "<option>Estad&iacute;stica y Probabilidad</option>" +
	                                  "<option>Econom&iacute;a y Empresa</option>" +
	                                  "<option>Antropolog&iacute;a II</option>" +
	                                  "<option>ECC II</option>" +
	                                "</select>" +
	                              "</div>" +
	                            "</div>" +
	                            
	                            "<div class='col-md-5'>" +
	                              "<div class='input-group'>" +
	                                "<span class='input-group-addon'>Curso</span>" +
	                                "<select class='form-control' id='years-savedReport'>" +
	                                  "<!-- HERE WILL BE LOADED ALL THE COURSES AVAILABLE -->" +
	                                "</select>" +
	                              "</div>" +
	                            "</div>" +
	                          "</div>" +
	                          
	                          
	                          "<div class='row'>" +
	                            "<div class='col-md-12'>" +
	                              "<div class='input-group'>" +
	                                "<span class='input-group-addon'>T&iacute;tulo</span>" +
	                                "<input type='text' class='form-control' id='graph_title-savedReport' placeholder='T&iacute;tulo del gr&aacute;fico'/>" +
	                              "</div>" +
	                            "</div>" +
	                          "</div>" +
	                          
	                          "<div class='row'>" +
	                            "<div class='col-md-12'>" +
	                              "<div class='input-group'>" +
	                                "<span class='input-group-addon'>Comentario</span>" +
	                                "<textarea class='form-control' id='comment-savedReport' rows='2' placeholder='Comentario acerca del gr&acute;fico'></textarea>" +
	                              "</div>" +
	                            "</div>" +
	                          "</div>" +
	                          
	                          
	                          "<div class='row'>" +
	                            "<div class='col-md-4'>" +
	                              "<button class='btn btn-default btn-lg' id='add-graph-savedReport'>" +
	                                "<span class='glyphicon glyphicon-plus-sign'></span> A&ntilde;adir al informe" +
	                              "</button>" +
	                            "</div>" +
	                          "</div>" +
	                          
	                        "</div><!-- /.panel-body -->" +
	                      "</div><!-- /.panel-collapse -->" +
	                    "</div><!-- /.panel -->";
			loadYears();
			var previous = $("#informesAnteriores .panel-body").html();
			$("#informesAnteriores .panel-body").html(previous + newGraph);
		}
		reportLoaded = true;
	});
}

function semester1Uploaded(){
	
	// Checks whether the 1 semester grades are uploaded
	$.post("ConnectionToRserve", 
			{
				option: "semester1Uploaded"
			},
			function(data){
				semester1Uploaded = (data.uploaded == "true");
			});
	
}