module ApplicationHelper
	CURRENCIES = {"AUD" => "australia", "BGN" => "bulgaria", "BRL" => "brazil", "CAD" => "canada", "CHF" => "liechtenstein", "CNY" => "china", "CZK" => "czech republic", "DKK" => "denmark", "EUR"=>"european union", "GBP" => "united kingdom", "HKD" => "hong kong", "HRK" => "croatia", "HUF" => "hungary", "IDR" => "indonesia", "ILS" => "israel", "INR" => "india", "JPY" => "japan", "KRW" => "south korea", "MXN" => "mexico", "MYR" => "malaysia", "NOK" => "norway", "NZD" => "new zealand", "PHP" => "philippines", "PLN" => "poland", "RON" => "romania", "RUB" => "russia", "SEK" => "sweden", "SGD" => "singapore", "THB" => "thailand", "TRY" => "turkey", "USD" => "united states", "ZAR" => "south africa"}


	def currencies_options
		@currencies_options = []
		CURRENCIES.each do |k,v|
  		@currencies_options << "<div class='item' data-value='#{k}'><i class='#{v} flag'></i>#{k}</div>"
  	end
  	@currencies_options = @currencies_options.join('').html_safe 
	end

	def check_period?(n)
		return params[:period] == n.to_s
	end
end
