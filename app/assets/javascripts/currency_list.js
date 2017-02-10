
$(document).on("turbolinks:load", function(){
	currencies = {"ARS": "argentina", "AUD": "australia", "BGN": "bulgaria", "BRL": "brazil", "CAD": "canada",
	 "CHF": "liechtenstein", "CNY": "china", "CZK": "czech republic", "DKK": "denmark", "DZD": "algeria",
	  "EUR": "european union", "GBP": "united kingdom", "HKD": "hong kong", "HRK": "croatia", "HUF": "hungary",
	   "IDR": "indonesia", "ILS": "israel", "INR": "india", "JPY": "japan", "KRW": "south korea", "MAD": "morocco", "MXN": "mexico",
	    "MYR": "malaysia", "NOK": "norway", "NZD": "new zealand", "PHP": "philippines", "PLN": "poland", "RON": "romania",
	     "RUB": "russia", "SEK": "sweden", "SGD": "singapore", "THB": "thailand", "TRY": "turkey", "TWD": 'taiwan',
	      "USD": "united states", "ZAR": "south africa"}

	var today = new Date();
  $('#rangestart').calendar({
    type: 'date',
    minDate: new Date(2000, 0, 1),
    maxDate: new Date(today.getFullYear(),today.getMonth(), today.getDate()),
    onChange: function(d){
    	console.log(d)
    	$("#startd").trigger("change")
    }
  });
	
	$("#currency, #startd").on("change", function(){
		console.log('/latest/'+$("#currency").val())
		date = $('#rangestart').calendar("get date")
		date_string=(date.getMonth()+1)+"-"+date.getDate()+"-"+date.getFullYear();
		$.ajax({
			url: '/latest/'+$("#currency").val(),
			data: {date: date_string },
			beforeSend: function(){
				$(".grid.segment").addClass("loading");
				return true;
			},
			success: function(data){
				console.log(currencies);
				$(".grid.segment").removeClass("loading");
				table = $(".currency-list.table.uno");
				body = table.find("tbody");
				$(".currency-list.table").find("tbody").children().remove();
				c = 0;
				for (var k in data.rates){
					if (c == 13){
						table = $(".currency-list.table.dos")
						body = table.find("tbody")
					}
					if (c == 25){
						table = $(".currency-list.table.tres")
						body = table.find("tbody")
					}
					tr = $("<tr>");
					tr.append($('<td><i class="ui '+currencies[k.toString()]+' flag"></i>'+k+'</td>'))
					tr.append($('<td>'+data.rates[k]+'</td>'))
					body.append(tr);
					c+=1;
				}

			}
		})

	});
	
});