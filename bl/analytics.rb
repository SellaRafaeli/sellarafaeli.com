$analytics = $mongo.collection('analytics')

def log_analytics(user_id, data)
	$analytics.add(data.merge(user_id: user_id))
end

get '/refresh' do true end