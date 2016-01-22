function showFormOption(obj){
	$("#frmSetupMapping .option").hide();
	$("#frmSetupMapping .option[data-target*='"+obj.value+"']").show();
	$("#frmXMLImportIframeContainer").hide();
}

function showImportForm(url){
	clone=$(".dynamic_modal_box").clone();
	$(clone).attr("id","tempmodelbox");
	$('body').append(clone);
	$(clone).on('hidden.bs.modal', function () {
	    $(clone).remove();
	}).on('shown.bs.modal', function() {
		modal_body=$(clone).find(".modal-body").first();
		$(modal_body).append("<iframe style='width:200px;' class='embed-responsive-item' src='"+url+" '></iframe>");
	});	
	$(clone).modal(true);
}

function validateImportedFile(o){
	ext=o.value.split('.').pop();
	accepts=o.getAttribute("accept");
	if(accepts.indexOf(ext)<=-1){
		alert("Please select valid file with extension as "+accepts);
	}else{
			window.App.Modal.show("Please wait","<div style='text-align:center'>..Loading..</div>","sm");
			$("#frmImportSourceContainer .s2").removeClass("text-muted").addClass("text-success");
			$("#frmImportSourceContainer .s1").removeClass("text-muted").addClass("text-success");
			$("#hiddenframe").remove();
			parent=$("#frmImportSource").parent();
			temp=$(parent).clone();
			$("<iframe id='hiddenframe' src='javascript:false;' style='position:absolute;top:-70px;left:-320px;'></iframe>").appendTo('body');
			$('#hiddenframe').contents().find('body').append($("#frmImportSource"));
			$(parent).replaceWith(temp);
			src=$('#hiddenframe').contents().find('#frmImportSource');
			$('#hiddenframe').on("load",function(event){
				window.App.Modal.close();
				$("#frmImportSourceContainer .s3").removeClass("text-muted").addClass("text-success");
				body=$('#hiddenframe').contents().find('body');
				btext=$(body).text();
				json=$.parseJSON(btext);
				if (json.rc==0){
					//window.location=json.redirect;
					$("#frmImportSourceContainer").hide();
					$("<iframe id='tempxmliframe' class='embed-responsive-item' src='"+json.redirect+"' style='border:none;margin:0px;padding:0px'></iframe>").appendTo('#frmXMLImportIframeContainer');
				}else if(json.rc==1){
					alert("errored");
				}
			});
			
			$(src).submit();	
			
			
		}
}

function beginImport(){
	$("#frmImportSource_file").trigger("click");
}


$(document).on('page:change',function(){
	$("#frmSetupMapping .option").hide();
	$("#frmSetupMapping").on("ajax:success",function(e,data,status,xhr){
		if(data['rc']==0){
			showImportForm(data['remoteform']);
		}
		else if(data['rc']==1){
			html="<ul id='frmSetupMapping_errors'>";
			$("#frmSetupMapping .form_errors").removeClass("form_errors");
			$.each(data['errors'],function(field,message){
				$("#frmSetupMapping *[name*='"+field+"']").first().addClass("form_errors");
				html+="<li class='text-danger'>"+field+" "+message+"</li>";
			});
			html+="</ul>";
			
			$("#frmSetupMapping_errors").remove();
			$("#frmSetupMapping").prepend(html);
		}
	}).on("ajax:error",function(e,data,status,xhr){
	});

});