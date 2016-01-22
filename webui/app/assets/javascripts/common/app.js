window.App = window.App || {};

window.App.init=function(){
	$.ajaxSetup({
	  dataType: 'json'
	});
	$("form[data-remote='true']").on('ajax:success',function(e, data, status, xhr){
		if(data['redirect'] !=undefined){
			window.location=data['redirect'];
		}
   });	
	$("#menu-toggle").click(function(e) {
	    e.preventDefault();
	    $("#wrapper").toggleClass("toggled");
	});
	   		
	$(".box-group").each(function(i,o){
		$(o).find("*[data-role='box-group-item']").each(function(si,so){
			$(so).on("click",function(e){
				pbg=$(this).parent();
				$(pbg).find(".active").each(function(ci,co){
					$(co).removeClass("active").addClass("text-muted");
					ct=$(co).attr("data-target");
					$(ct).hide();
				});
				$(this).removeClass("text-muted").addClass("active");
				st=$(this).attr("data-target");
				$(st).show();
			});	
			sot=$(so).attr("data-target");
			if($(so).hasClass("active")){
				$(sot).show();
			}else{
				$(sot).hide();
			}
			
		});
	});   
   
   $("#button").click(function(event){ 
    $.ajax({
        type: "POST",
        url: "/slot_allocations/" + slotallocation_id,
        dataType: "json",
        data: {"_method":"delete"},
        complete: function(){
            $( "#SlotAllocationForm" ).dialog( "close" );
            alert("Deleted successfully");
        }
    });
    event.preventDefault();
	});
   
   window.App.Modal.init();
  
};

window.App.datagrid={
	'edit':function(target){
		console.log(target);
		$(target +" *[data-role='datagrid-edit-item']").prop("disabled",false);
	},
	'toggle':function(target){
		$(target +" *[data-role='datagrid-edit-item']").prop("disabled", function (_, val) { return ! val; });
	},	
	'remove':function(target,dataid){
		
		var r = confirm("Are you sure ?");
		
		if(r==true){
			$.ajax({
			  type: "POST",	
			  dataType: "json",
			  url: target,
			  data: {"_method":"delete"},
			  success: function(e,status,data,xhr){
			  	response=data.responseJSON;
			  	if(response && response['rc']==0){
			  		$(".datagrid-row[data-id='"+response['callback_data_id']+"']").remove();
			  	}
			  }
			});
		}
		
	}
};

$(document).on("page:change",function(){
	window.App.init();
});