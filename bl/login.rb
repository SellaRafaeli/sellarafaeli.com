get '/login' do
  erb :login, layout: :layout2
end

get '/sign_up' do
  erb :sign_up, layout: :layout2
end

get '/logout' do
  sesh.clear
  flash.message = 'Sorry to see you go!'
  redirect '/'
end

post '/signup' do
  require_fields([:email])
  email = pr[:email].to_s[0..200]
  
  if $users.get(email: email)
    flash.message = 'That email is taken. Login or try another.'
    redirect '/login'
  end
  
  user = $users.add(email: email)
  sesh[:user_id] = user[:_id]
  flash.message = 'Welcome!'
  redirect '/profile'
end

post '/login' do
  email = pr[:email]
  token = guid
  user  = $users.get(email: email)  

  if user
    flash.message = 'Login link sent to your email.'
    subj  = "Login Link from TopJobs - #{Time.now}"
    $users.update_id(user[:_id], login_token: token)
    msg   = "<strong>Hello</strong>, <a href='http://localhost:9000/login_token?token=#{token}'>click this link to enter.</a></div>"
    send_email(pr[:email], subj, msg)
  else 
    flash.message = 'No such user. Sign Up, perhaps?'
    redirect '/sign_up'
  end
  redirect back
end

get '/login_token' do
  token = pr[:token]
  if token && (user = $users.get(login_token: token))
    sesh[:user_id] = user[:_id]
    flash.message = "Welcome back, #{user[:email]}"
    $users.update_id(user[:_id],email_token: nil)
    redirect '/'
  else 
    flash.message = "No such user."
    redirect '/'
  end
end