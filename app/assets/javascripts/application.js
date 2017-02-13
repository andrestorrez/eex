// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require semantic-ui/dropdown
//= require semantic-ui/transition
//= require semantic-ui/popup


$(document).on("turbolinks:load", function(){
	$(".ui.dropdown").dropdown();

	$("#amount1").on("keyup", function(){
		get_exr(1);
	});

	$("#amount2").on("keyup", function(){
		get_exr(2);
	});

	$("#currency1").on("change", function(){
		get_exr(1);
	});

	$("#currency2").on("change", function(){
		get_exr(1);
	});
	
	function get_exr(order){
		if (order == 1){
			c = $("#currency1").val()+"-"+$("#currency2").val();
			a = $("#amount1").val();
		}else{
			c = $("#currency2").val()+"-"+$("#currency1").val();
			a = $("#amount2").val();
		}

		$.ajax({
			url: '/latest/'+c,
			success: function(data){
				console.log(data);
				console.log(data.rate * parseFloat(a));
				console.log("#amount"+(order==1 ? "1" : "2"));
				if (data.rate){
					input = $("#amount"+(order==1 ? "2" : "1"));
					input.val((data.rate * parseFloat(a)).toFixed(4));
					input.parent().transition('pulse');
				}
			}

		});
	}

});
	
