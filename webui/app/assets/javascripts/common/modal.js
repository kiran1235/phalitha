/*
 * Author: Kiran Talapaku
 * File Name: datagrid.js
 * File Type: Javascript
 * Version: 1.0
 * Requirements: Bootstrap Framework, Jquery
 */

window.App = window.App || {};

window.App.Modal={
	'init':function(){
		if (typeof jQuery != 'undefined') {
			$("*[data-role='modal']").on("click",function(event){
				event.preventDefault();
				target=$(this).attr("data-target");
				size=$(this).attr("modal-size");
				title=$(this).attr("modal-title");
				type=$(this).attr("model-type");
				if (title == undefined)
				{
					title="Message";
				}
				
				if(size == undefined){
					size="sm";
				}
				
				if(target == undefined){
					return true;
				}
				
				if(type && type=="if"){
					iframe="<div class=''><iframe class='' src='"+target+"'></iframe></div>";
					window.App.Modal.show(title,iframe,size);
				}else{
					window.App.Modal.show(title,"<div style='text-align:center'>..Loading..</div>",size);
			        $.ajax({
			            type: "GET",
			            url: target,
			            dataType: "html",
			            contentType: "application/html; charset=utf-8",
			            success: function (data) {
			                console.log(data);
			                window.App.Modal.show(title,data,size);
			            },
			            error: function (textStatus, errorThrown) {
			                console.log(errorThrown);
			            }
			
			        });					
				}
				
				
			
			});
		}
	},	
 'show':function(title,data,size){
		$("#dynamic_modal_box .modal-dialog").removeClass("modal-sm");
		$("#dynamic_modal_box .modal-dialog").removeClass("modal-lg");
		if(size=="lg"){
			$("#dynamic_modal_box .modal-dialog").addClass("modal-lg");
		}else if(size=="sm"){
			$("#dynamic_modal_box .modal-dialog").addClass("modal-sm");
		}
		$("#dynamic_modal_box .modal-title").text(title);
		$("#dynamic_modal_box .modal-body").empty();		
		$("#dynamic_modal_box .modal-body").append($(data));
		$('#dynamic_modal_box').modal('show');
		//modal-title
	},
	'close':function(){
		$('#dynamic_modal_box').modal('hide');
	}
};
