$orgs = $mongo.collection('orgs')

get '/search' do
  erb :search, layout: :layout2
end


