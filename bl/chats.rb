$msgs = $mongo.collection('msgs')



get '/chats' do
  erb :'chats/chats', layout: :layout2
end

get '/chats/:user_id' do
  erb :'chats/single_chat', layout: :layout2
end

post '/send_msg' do
  $msgs.add(from: cuid, to: pr[:user_id], text: pr[:text])
  redirect back
end