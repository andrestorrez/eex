json.base @base
if @versus
	json.versus @versus
end
if @date
	json.date @date
else
	json.start @start
	json.end @endd
end
if @rates.length == 1
	json.rate @rates.first[1]
else
	json.rates @rates
end