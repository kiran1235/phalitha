//$.phalitha = $.phalitha || {};

//$.phalitha = {
$.phalitha = phalitha ={
	'csrf':"",
	'init':function(){
		$("*[data-target='ph:login']").on("click",function(e){
			//$(this).off(e);
			e.preventDefault();
			$.phalitha.login(this);
			return false;
		});
		$("*[data-target='ph:login']").css({
			'background-color':'#d1d1d1',
			'font': 'bold 11px Courier',
			'text-decoration': 'none',
			'background-color': '#0769AD',
			'color': '#fff',
			'padding': '5px',
			'border-top': '1px solid #CCCCCC',
			'border-right': '1px solid #333333',
			'border-bottom': '1px solid #333333',
			'border-left': '1px solid #CCCCCC'
			
		});
		$.phalitha.modal.init();
	},
	'source':function(route){
		var scripts = document.getElementsByTagName('script');
		var index = scripts.length;
		route = (route == undefined) ? "" : route;
		for(i=0;i<index;i++)
		{
			if (scripts[i].src.indexOf('phalitha.js') >0){
				return scripts[i].src.replace('phalitha.js','api/'+route);
			}
		}
		return window.location.href+"api/"+route;
	},
    'fire': function(obj, name, data) {
      var event = $.Event(name);
      obj.trigger(event, data);
      return event.result !== false;
    },	
	'login':function(obj){
		$.phalitha.modal.show();
		$.phalitha.modal.loadwithurl($.phalitha.source('auth'));
	},
	'ajax': function(options){
		return $.ajax(options);
	},
	'auth':function(obj){
 		$.ajax({
			url:$.phalitha.source('auth'),
			data:$(obj).serialize(),
			async:true,
			type:"post",
			dataType:"json",
			crossDomain:true,
			success:function(json, status,xhr){
				if(json['rc']==1){
					$(obj).find("input").css({
						"border" : "1px solid red"
					});
				}else if(json['rc']==0){
					token=json['token'];
					console.log(token)
					$.phalitha.modal.loadwithhtml('<center><img src="'+json['url']+'" /><br><p> Please close or click until page refreshed</p></center>');
					data=[]
					i=0;
					$("*[data-target='ph:element']").each(function(index,obj){
						attr=$(obj).attr("data-rel");
						if(attr.length >0){
							data[i]=attr;
							i++;
						}
					});
					
					if(data.length >0){
						$.ajax({
							url:$.phalitha.source('parse'),
							data:"data="+data.toString()+"&token="+token,
							type:"post",
							dataType:"json",
							success:function(json, status,data, xhr){
								if(json['rc']==1){
									$.phalitha.modal.loadwithhtml('<center>Opps!! Something went wrong, please close and try again</center>');
								}else if(json['rc']==0){
									$(json['values']).each(function(index,obj){
										$("*[data-target='ph:element'][data-rel='"+obj['accesscode']+"']").text(obj['value']);
									});
									$.phalitha.modal.hide();
								}
							}
						});
					}
				}
			}
		}); 
	},
	'modal':{
		'window':'',
		'isshowing':false,
		'init':function(){
			var parent=$("#phalithabox");
			if(parent.length){
				var child=$("#phalithabox_body");
				if (child.length){
					child.remove();
				}
				var child=$("<div id='phalithabox_body'></div>");
				$(child).appendTo(parent);
			}	else	{
					var body=$("body");
					var box=$("<div id='phalithabox' class='modal'><div style='background-color:#fff;margin-top:5em;margin-left:50em;border:1px solid #ddd;width:250px;'><div id='phalithabox_body'>..loading..</div></div></div>");
					$(box).appendTo(body);
					$.phalitha.modal.isshowing=false;
					$(box).modal('hide');
			}
			
		},
		'show':function(){
			$("#phalithabox").modal('show');
		},
		'hide':function(){
			$("#phalithabox").modal('hide');
		},
		'loadwithhtml':function(data){
			$("#phalithabox_body").html(data);
		},
		'loadwithurl':function(url){
 			$.ajax({
				url:url,
				async:true,
				success:function(data){
					$.phalitha.modal.loadwithhtml(data);
					$("form[data-target='ph:auth']").on('submit',function(e){
						e.preventDefault();
						$.phalitha.auth(this);
					});	
				}
			});
 	
		}
	}
}

if(typeof jQuery=='undefined') {
    var headTag = document.getElementsByTagName("head")[0];
    var jqTag = document.createElement('script');
    jqTag.type = 'text/javascript';
    jqTag.src = '//code.jquery.com/jquery-1.11.3.min.js';
    jqTag.onload = $.phalitha.init;
    headTag.appendChild(jqTag);
} else {
	$.phalitha.init();
}