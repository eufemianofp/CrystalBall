$(document).ready(function(){
	
	state();
	upload();
});

function state(){
	
	$.post("ConnectionToRserve",
	  {
	    option: "state"
	  },
	  function(data){
		  $("#state").html(data);
	  });
}

function upload(){
	
	var tipo = null;
	
	$('.upload').submit(function(e){
		// Prevents the tag "<button>" to submit the form by itself
		e.preventDefault();
		
		// Stores the type of upload (i.e. "Parciales" or "Finales")
		tipo = $(this).find('input:hidden').attr('name');
		
		// Retrieves the form data in order to send it to the server
	    var formData = new FormData(this);
		
		if (tipo == "finales") {
			
			// Have the files been attached?
			var notas_finales = $('#notas_finales').val();
			var admision_anticipada = $('#admision_anticipada').val();
			var admision_ordinaria = $('#admision_ordinaria').val();
			
			if (notas_finales == "") {
				
				alertify.alert("Adjunte un archivo para subir las notas finales.");
				return;
			} else if (admision_anticipada == "") {
				
				alertify.alert("Adjunte el archivo csv con las admisiones en convocatoria anticipada.");
				return;
			} else if (admision_ordinaria == "") {
				
				alertify.alert("Adjunte el archivo csv con las admisiones en convocatoria ordinaria.");
				return;
			} else {
				
				var filename_anticipada = admision_anticipada.split('\\').pop();
				var filename_ordinaria = admision_ordinaria.split('\\').pop();
				
				// alert("Anticipada: " + filename_anticipada + ", " + filename_anticipada.startsWith('Ltdo'));
				// alert("Ordinaria: " + filename_ordinaria + ", " + filename_ordinaria.startsWith('Ltdo'));
				
				if (!filename_anticipada.startsWith('Ltdo')) {
					
					alertify.alert("El nombre del archivo csv con las admisiones anticipadas debe empezar por 'Ltdo'.");
					return;
				} else if (!filename_ordinaria.startsWith('Ltdo')) {
					
					alertify.alert("El nombre del archivo csv con las admisiones ordinarias debe empezar por 'Ltdo'.");
					return;
				} else {
					
					alertify.set({ buttonReverse: true });
					alertify.set({ labels: {
					    ok     : "Aceptar",
					    cancel : "Cancelar"
					} });
					
					var message = "&iquest;Seguro que desea subir las notas finales?";
					alertify.confirm(message, function(e) {
						if (e) uploadFiles(tipo, formData);
					});
				}
			}
		} else if(tipo == "parciales") {
		
			// Has the file been attached?
			var file = $('#notas_parciales').val();
			if (file == "") {
				alertify.alert("Adjunte un archivo para subir las notas parciales.");
				return;
			}
		
			uploadFiles(tipo, formData);
		}
	});
}

function uploadFiles(tipo, formData){
	
	$.ajax({
        url: 'UploadFile',
        type: 'POST',
        data: formData,
        cache: false,
        contentType: false,
        processData: false,    
        success: function(data){
        	if(tipo == "parciales"){
        		if(data.state == "saved")
        			if(data.updated == "true"){
    					alertify.success("El archivo \"" + data.name + "\" se ha subido con &eacute;xito, y los datos" +
    								 	 " se han actualizado correctamente. Ya puede ver las nuevas predicciones.");
        				state();
        			}else
    					alertify.error("El archivo \"" + data.name + "\" se ha subido con &eacute;xito, pero ha " +
    								   "habido un problema al actualizar los datos. Intente actualizar de nuevo m&aacute;s " +
    								   "tarde.");
        		else alertify.error("Ha habido un problema al subir el archivo \"" + data.name + "\". Intente actualizar" +
        							" de nuevo m&aacute;s tarde.");
        	}else if(tipo == "finales"){
        		if(data.state == "saved")
        			if(data.updated == "true"){
        				alertify.success("Los archivos se han subido con &eacute;xito, y los datos" + 
        								 " se han actualizado correctamente.");
        				state();
        			}else
        				alertify.error("Los archivos se han subido con &eacute;xito, pero ha habido un " +
	 								   "problema al actualizar los datos. Intente actualizar de nuevo m&aacute;s " +
	 								   "tarde");
        		else 
        			alertify.error("Ha habido un problema al subir el archivo \"" + data.name + "\".");
        	}
        }
    });
	
}
