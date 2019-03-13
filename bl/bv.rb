CRUNCHBASE_MOCK_DATA_URL = "https://spreadsheets.google.com/feeds/list/1DPp6ZRs7h46CqbF7g3QS9E60jyM2PTdqpmYWtl6IydE/1/public/values?alt=json"

SFDC_MOCK_DATA_URL = "https://spreadsheets.google.com/feeds/list/1DPp6ZRs7h46CqbF7g3QS9E60jyM2PTdqpmYWtl6IydE/2/public/values?alt=json"

def spreadsheet_to_arr(url)
	rows = JSON.parse(open(url).read)['feed']['entry'].map {|row| kvs = row.select {|k,v| k.start_with?('gsx$') } }.map {|row| row = row.map {|k,v| [k.sub('gsx$',''),v['$t'] ]; }.to_h };
end

def crunchbase_mock_data
	spreadsheet_to_arr(CRUNCHBASE_MOCK_DATA_URL)
end

def sfdc_mock_data
	spreadsheet_to_arr(SFDC_MOCK_DATA_URL)
end

def org_data(name)
	cb_rows = crunchbase_mock_data
	cb_data = cb_rows.select {|r| r.hwia[:companyname].to_s.downcase == name.to_s.downcase }[0] || {}

	sfdc_rows = sfdc_mock_data
	sfdc_data = sfdc_rows.select! {|r| r.hwia[:companyname].to_s.downcase == name.to_s.downcase }[0] || {}

	sfdc_data.merge(cb_data)
end

def crunchbase_data_old(name = 'foo')
	{
	labels: ['January 2019', 'February 2019', 'March 2019'],
	datasets: [{
		label: 'Sequoia',
		backgroundColor: 'red',
		data: [
			1, 2, 3
		]
	}, {
		label: 'Battery Ventures',
		backgroundColor: 'blue',
		data: [
			0, 2, 2
		]
	},
	{
		label: 'Khosla Ventures',
		backgroundColor: 'green',
		data: [
			0, 0, 2
		]
	}
	]
	};
end

def sfdc(name = 'foo')
	{
		sfdc: 'hello'
	}
end

get '/bv' do
	erb :'bv/battery_ventures'
end

get '/bv/org' do
	#{crunchbase: crunchbase_data, sfdc: sfdc}
	org_data(pr[:name])
end

