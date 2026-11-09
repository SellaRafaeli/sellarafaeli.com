$requests = $mongo.collection('requests') #track http requests
mongo_expire_after($requests, 7.days.to_i) # keep one week

def log_request(data)
  data = data.just(:time_took)
  data = data.merge({username: cusername, user_id: cuid, path: request_path, params: _params})
  $requests.add(data)
end