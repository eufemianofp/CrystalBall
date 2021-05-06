$(document).ready(function(){
	
	loadYears();
	onClickStudent();
	onResultadosClick();
	onEnterPress();
	search();
	selectYear();
});

var carnetActual;
var finished = true;

function loadYears(){
	
	// LOADS ALL THE ACADEMIC YEARS WITH RECORDS
	$.post("ConnectionToRserve", 
		{
			option: "cargarCursos",
			currentYear: true
		},
		function(data){
			$("select.form-control").html(data);
		});
}

function onEnterPress(){
	
	$("#carnet").keypress(function(key) {
	    if(key.which == 13){
	    	// Stores the value of the student number
    		var carnet = $(".list-group li").html();
    		
    		// Just selects the student if there is only one student, and it's different from the previous one
	        if($(".list-group li").length == 1 && carnet != carnetActual){
	    		selectStudent(carnet, $(".list-group li"));
	        }
	    }
	});
}

function onResultadosClick(){
	
	$("#resultados").on("click", function(){
		if(!$("#resultados").hasClass("selected") && carnetActual != null){
			
			// Activates the descriptive button. Although this is not necessary, it is useful to control
			// when the button is clicked or not, to avoid calling the server every time the button is clicked
		    $("#resultados").addClass("selected");
		    resultados(carnetActual);
		}
	});
	
}

function onClickStudent(){
	
	// WHEN A STUDENT LINK IS CLICKED
	$(".list-group").on("click", ".list-group-item", function(){
		
		// Stores the value of the student number
		var carnet = $(this).html();
		
	    selectStudent(carnet, $(this));
	});
	
}

function resultados(carnet){
	
    // Function to retrieve the student marks from the server
    $.post("ConnectionToRserve",
	  {
	    option: "resultados",
	    carnet: carnet,
	  },
	  function(data){
		  $(".panel-body").html(data);
	  });
}

function predicciones(carnet){
	
	//alert(carnet);
	
	// Function to retrieve the student marks from the server
    $.post("ConnectionToRserve",
	  {
	    option: "predicciones",
	    carnet: carnet,
	  },
	  function(data){
		  $(".panel-body").html(data);
	  });
}

function search(){
	
	//WHEN THE USER LOOKS FOR AN SPECIFIC STUDENT
	$("#carnet").keyup(function(key){
		
		if(key.which == 13) return; // if the key up is the Enter key, do nothing
		if(!finished) return; // if the previous thread has not finished, do nothing
		
		var carnet = $("#carnet").val();
		
		$(".panel.panel-default .panel-heading").html("Resultados de b&uacute;squeda");
		
		// Function to retrieve the list of students of a particular year
		if(carnet != ""){
			finished = false;
			$.post("ConnectionToRserve", 
			  {
				option: "buscar",
				carnet: carnet
			  },
			  function(data){
				  if(data.existe == "false"){
					  $("#no_existe").html("<div class='alert alert-danger'>El carnet introducido no existe.</div>");
					  $(".list-group").html("<br>" +
								              "<p>Aqu&iacute; se mostrar&aacute;n los alumnos cuando seleccione un " +
								                 "curso o cuando busque un alumno en concreto. Haga " +
								                 "click en &eacute;l para mostrar su informaci&oacute;n en el panel de " +
								                 "la derecha</p>" +
								             "<br>");
				  }else{
					  $("#no_existe").html("");
					  $(".list-group").html(data);
				  }
				  finished = true;
			  });
		}else{
			$("#no_existe").html("");
			$(".panel.panel-default .panel-heading").html("Lista de alumnos");
			$(".list-group").html("<br>" +
					              "<p>Aqu&iacute; se mostrar&aacute;n los alumnos cuando seleccione un " +
					                 "curso o cuando busque un alumno en concreto. Haga " +
					                 "click en &eacute;l para mostrar su informaci&oacute;n en el panel de " +
					                 "la derecha</p>" +
					              "<br>");
		}
	});
}

function selectStudent(carnet, selectedStudent){
	
	if(!$("#resultados").hasClass("selected") || carnet != carnetActual){
		// Updates the value of the current student number
		carnetActual = carnet;
		
		// Function to put the id number of the student in the header of the panel
	    $("#carnetPanel").html("Carnet: <strong>" + carnet + "</strong>");
	    
	    // Function to change the selected link to bold, and removes the bold to any other link
	    $(".list-group-item.activo").removeClass("activo");
	    selectedStudent.addClass("activo");
	    
	    // Retrieves the student marks, and puts them in the panel
	    resultados(carnet);
	    
	    // Activates the descriptive button
	    $("#resultados").addClass("selected");
	    
	    // When the other button, "#predicciones", is clicked, we call the function "predicciones()" to retrieve
	    // the predictions. We also have to remove the class "selected" added to #resultados, otherwise it wouldn't
	    // change. Then we prepare the button "#resultados" for when it is pressed
		$("#predicciones").on("mousedown", function(){
			$("#resultados").removeClass("selected");
		});
		
		// Removes the previous listener
		$("#predicciones").off("mouseup");
		
		// Sets the new listener to the new 
		$("#predicciones").on("mouseup", function(){
			predicciones(carnet);
		});
		
	}
	
}

function selectYear(){
	
	// WHEN THE SELECT MENU WITH THE ACADEMIC YEARS CHANGES ITS VALUE
	$("select.form-control").on("change", function(){
		var year = $(this).val();
		
		if(year == "-- Elija un curso --"){
			$(".list-group").html("<br>" +
					              "<p>Aqu&iacute; se mostrar&aacute;n los alumnos cuando seleccione un " +
					                 "curso o cuando busque un alumno en concreto. Haga " +
					                 "click en &eacute;l para mostrar su informaci&oacute;n en el panel de " +
					                 "la derecha</p>" +
					              "<br>");
			$(".panel.panel-default .panel-heading").html("Lista de alumnos");
			return;
		}
		
		// Function to retrieve the list of students of a particular year
		$.post("ConnectionToRserve",
		  {
			option: "alumnos",
			year: year
		  }, 
		  function(data){
			$(".list-group").html(data);
			$(".panel.panel-default .panel-heading").html("Lista de alumnos. Curso " + year);
		});
	});
	
}