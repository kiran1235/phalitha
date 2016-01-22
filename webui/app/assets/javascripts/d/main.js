$(document).ready(function(){
	$.ajaxSetup({
	  dataType: 'json'
	});
	
	$("form[data-remote='true']").on('ajax:success',function(e, data, status, xhr){
		if(data['redirect'] !=undefined){
			window.location.assign(data['redirect']);
		}
   });
});