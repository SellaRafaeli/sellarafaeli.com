$users = $mongo.collection('users')

USER_PROFILE_FIELDS = []
USER_BASIC_FIELDS   = ["nick", "desc", "interest", "experience"] + ["linkedin", "facebook", "github", "homepage", "other"]

USER_PREF_CHECKS    = ['pay_check', 'location_check', 'role_check', 'raised_check', 'min_people_check', 'max_people_check', 'remote_friendly_check', 'part_time_friendly_check', 'only_eng_check']
USER_PREF_LIMITS    = ['pay_limit', 'location_limit', 'role_limit', 'raised_limit', 'min_people_limit', 'max_people_limit']

USER_FIELDS         = USER_BASIC_FIELDS + USER_PROFILE_FIELDS + USER_PREF_CHECKS + USER_PREF_LIMITS

def search_users(crit)
  $users.search_by(USER_BASIC_FIELDS, crit[:q])
end

def is_org
  cu && cu[:is_org]
end

get '/profile' do  
  erb :profile, layout: :layout2
end

get '/profile/:id/?:bla?' do  
  erb :user_profile, layout: :layout2
end

post '/profile' do
  $users.update_id(sesh[:user_id],pr.just(USER_FIELDS))  
  flash.message = 'Saved.'
  redirect back
end

get '/prefs' do
  erb :prefs, layout: :layout2
end

post '/prefs' do
  USER_PREF_CHECKS.each {|f| 
    if pr[f] == 'on'
      pr[f] = true
    else 
      pr[f] = false
    end
  }  

  $users.update_id(sesh[:user_id],pr.just(USER_FIELDS))  
  flash.message = 'Awesome!'
  redirect back
end
