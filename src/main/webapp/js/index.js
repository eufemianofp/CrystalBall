$(document).ready(function(){
    $("#user").focus();
    $("input").mouseenter(function(){$(this).focus();});
    $("form").submit(function(e){
    	var user = $("#user").val();
    	var password = $("#password").val();
    	
    	if(user == ""){
    		e.preventDefault();
    		alertify.alert("Introduzca su nombre de usuario");
    		$("#user").focus();
    	}else if(password == ""){
    		e.preventDefault();
    		alertify.alert("Introduzca su contrase&ntilde;a");
    		$("#password").focus();
    	}else if(user == "" && password == ""){
    		e.preventDefault();
    		alertify.alert("Introduzca su nombre de usuario y su contrase&ntilde;a");
    		$("#user").focus();
    	}
    });
});