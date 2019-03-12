def crunchbase_data(name = 'foo')
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
	{crunchbase: crunchbase_data, sfdc: sfdc}
end

