$analytics = $mongo.collection('analytics')

def log_analytics(user_id, data)
	$analytics.add(data.merge(user_id: user_id))
end

## Site tracking: every page load + click, sent by public/js/track.js

$page_events = $mongo.collection('page_events')
begin
  $page_events.indexes.create_many([{key: {created_at: -1}}, {key: {vid: 1, created_at: -1}}])
rescue => e
  puts "page_events index error: #{e}"
end

TRACK_SCRIPT_TAG = '<script src="/js/track.js?v=1" defer></script>'
TRACK_FIELDS     = %w(type path query title referrer screen lang tz vid sid tag text href el_id el_class)
BOT_UA_REGEX     = /bot|crawl|spider|slurp|headless|lighthouse|pingdom|preview|facebookexternalhit|curl|wget|python|scrapy|phantom|selenium|puppeteer|playwright/i

def client_ip
  (request.env['HTTP_X_FORWARDED_FOR'].to_s.split(',').first || request.ip).to_s.strip
end

def referrer_host(ref)
  host = URI.parse(ref.to_s).host.to_s.sub(/\Awww\./, '')
  host.presence
rescue
  nil
end

post '/track' do
  data = JSON.parse(request.body.read) rescue {}
  doc  = data.is_a?(Hash) ? data.slice(*TRACK_FIELDS).transform_values { |v| v.to_s[0, 500].presence } : {}
  halt 204 unless doc['type'].in?(%w(pageview click))

  ua  = request.user_agent.to_s
  ref = referrer_host(doc['referrer'])
  doc.merge!(
    host:     request.host,
    ref_host: (ref unless ref.to_s.end_with?(request.host.sub(/\Awww\./, ''))),
    ip:       client_ip,
    ua:       ua[0, 300],
    mobile:   !!(ua =~ /mobile|android|iphone|ipad/i),
    bot:      !!(ua =~ BOT_UA_REGEX) || ua.empty?
  )
  $page_events.add(doc.reject { |_, v| v.nil? })
  halt 204
rescue => e
  puts "track error: #{e}"
  halt 204
end

# Called from the after-filter: adds the tracker to every HTML page we render.
def inject_tracking_script!
  return unless request.get? && response.status == 200
  return if request.path_info.start_with?('/admin') # don't count admin views
  return unless response['Content-Type'].nil? || response['Content-Type'].to_s.include?('text/html')
  return unless response.body.is_a?(Array) && response.body.all? { |s| s.is_a?(String) }

  html = response.body.map(&:b).join # bytes: bodies like File.read can carry any encoding
  return if html.include?('/js/track.js') || !html.lstrip.start_with?('<')
  idx  = html.rindex(/<\/body>/i) || html.length # fragments without </body> (e.g. my_judaism.html): append
  body(html.insert(idx, TRACK_SCRIPT_TAG + "\n").force_encoding(Encoding::UTF_8))
rescue => e
  log_e(e) # never break a page over analytics
end

get '/refresh' do true end
