class ApiController < ApplicationController

	DEFAULT_BASE = "EUR"
	BASE_URL = "https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.%{versus}.#{DEFAULT_BASE}.SP00.A?startPeriod=%{start_date}&endPeriod=%{end_date}"

	def latest
		query = params[:attrs].split("-")
		@base = query[0].try(:upcase)
		@versus = query[1].try(:upcase)
		@rates = {}
		@date = get_valid_date(Time.now)

		is_default_base = @base == DEFAULT_BASE
		real_vs = is_default_base && @versus.blank? ? nil : "#{is_default_base ? nil : @base}#{@base && @versus && !is_default_base ? '+': nil}#{@versus ? "#{@versus}" : nil}"
		url_request = BASE_URL % {versus: real_vs, start_date: @date, end_date: @date }

		response = open_request(url_request)
		if response
			currency = nil
			rate = nil
			response.each do |line|
				tmp = line.match(/generic:Value id="CURRENCY" value="([[:alpha:]]+)"/)
				currency = tmp != nil && tmp != currency ? tmp : currency
				if currency 
					tmp = line.match(/generic:ObsValue value="([[:graph:]]+)"/)
					rate = tmp != nil && tmp != rate ? tmp : rate
					if rate
						@rates[currency[1]] = rate[1].to_f
						rate = nil
					end
				end
			end
			unless is_default_base
				base_rate = 1 / @rates[@base]
				@rates[DEFAULT_BASE] = 1
				@rates.each do |k, v|
					if @versus && k != @versus
						@rates.delete(k)
					else
						@rates[k] = (v * base_rate).round(5)
					end
				end
			end
			@date = Date.strptime(@date).strftime("%m-%d-%Y")
		else
			render json: {message: "Wrong currency"}, status: 422
		end

	end

	def historical
		query = params[:attrs].split("-")
		@base = query[0].try(:upcase)
		@versus = query[1].try(:upcase)
		@rates = {}

		is_default_base = @base == DEFAULT_BASE
		real_vs = is_default_base && @versus.blank? ? nil : "#{is_default_base ? nil : @base}#{@base && @versus && !is_default_base ? '+': nil}#{@versus ? "#{@versus}" : nil}"
		range = params[:start] && params[:end]

		if range
			start_date = get_valid_date(Date.strptime(params[:start], '%m-%d-%Y'))
			end_date = get_valid_date(Date.strptime(params[:end], '%m-%d-%Y'))
			@start =  Date.strptime(start_date)
			@endd =  Date.strptime(end_date)
			url_request = BASE_URL % {versus: real_vs, start_date: start_date, end_date: end_date }
		else
			date = get_valid_date(Date.strptime(params[:date], '%m-%d-%Y'))
			@date =  Date.strptime(date)
			url_request = BASE_URL % {versus: real_vs, start_date: date, end_date: date }
		end

		if (range || params[:date]) && query.length > 1 && ((@start && @endd && @start.year > 1999 && @endd.year > 1999) ||
				(@date && @date.year > 1999)) && response = open_request(url_request)

			currency = nil
			date = nil
			rate = nil
			tmp_rates = {}

			response.each do |line|
				tmp = line.match(/generic:Value id="CURRENCY" value="([[:alpha:]]+)"/)
				currency = tmp != nil && tmp != currency ? tmp : currency

				if currency 
					tmp = line.match(/generic:ObsValue value="([[:graph:]]+)"/)
					rate = tmp != nil && tmp != rate ? tmp : rate
					tmp = line.match(/generic:ObsDimension value="([[:graph:]]+)"/)
					date = tmp != nil && tmp != date ? tmp : date

					if rate && date
						date_ftime = Date.strptime(date[1]).strftime('%m-%d-%Y')
						tmp_rates[date_ftime] ||= {}
						tmp_rates[date_ftime][currency[1]] = rate[1].to_f
						rate = nil
						date = nil
					end
				end
			end

			#unless is_default_base
				tmp_rates.each do |k, v|
					v[DEFAULT_BASE] = 1
					base_rate = 1 / v[@base]
					
					v.each do |kk, vv|
						if kk == @versus
							@rates[k] = (vv * base_rate).round(5)
						end
					end
				end
			#end
			if @start && @endd
				@start =  @start.strftime("%m-%d-%Y")
				@endd =  @endd.strftime("%m-%d-%Y")
			else
				@date = @date.strftime("%m-%d-%Y")
			end
				
			render 'latest'	
		else
			render json: {message: "Wrong parameters", code: "422"}, status: 422
		end
		

	end

	private
=begin
	def get_response(base = "EUR", versus = nil, time = "latest")
		begin
			query = versus ? "&symbols=#{versus}" : ""

			resp = HTTParty.get("http://api.fixer.io/#{time}?base=#{base}#{query}")
			return resp
		rescue => e
			return nil
		end
	end
=end

	def open_request(url)
		begin
			return open(url)
		rescue => e
			return nil
		end
	end

	def get_valid_date(date)
		date = date.to_datetime.change(hour: Time.now.utc.hour, min: Time.now.utc.min)
		today_limit = Time.now.in_time_zone("CET").change(hour: 16, min:15)
		return (date > today_limit || date < today_limit.beginning_of_day ? date : date - 1.day).strftime('%Y-%m-%d')
	end
end