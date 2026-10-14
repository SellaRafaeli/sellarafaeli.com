## Admin analytics dashboard: /admin (overview) and /admin/page?path=... (one page).
## Built from $page_events (see analytics.rb); days are in DIGEST_TZ (see analytics_digest.rb).

DASH_RANGES     = [['7', '7 days'], ['30', '30 days'], ['90', '90 days'], ['365', '1 year']]
SESSION_TIMEOUT = 30.minutes # a gap longer than this inside one tab starts a new session

AI_SOURCES     = /chatgpt|openai|perplexity|claude\.ai|gemini|copilot|phind|you\.com/
SEARCH_SOURCES = /(\A|\.)(google|bing|duckduckgo|yahoo|yandex|baidu|ecosia|brave|kagi|startpage|qwant|naver)(\.|\z)/
SOCIAL_SOURCES = /(\A|\.)(t\.co|twitter|x\.com|linkedin|lnkd\.in|facebook|fb|instagram|reddit|youtube|whatsapp|t\.me|telegram|threads|bsky|mastodon|news\.ycombinator|lobste\.rs|medium|substack)(\.|\z)/
EMAIL_SOURCES  = /mail|outlook|newsletter/

def h(s)
  CGI.escapeHTML(s.to_s)
end

def fmt_num(n)
  n.to_i.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
end

def fmt_duration(secs)
  secs = secs.to_i
  secs < 60 ? "#{secs}s" : "#{secs / 60}m #{(secs % 60).to_s.rjust(2, '0')}s"
end

def pct(n, total)
  total.to_i > 0 ? (n * 100.0 / total).round : 0
end

def median(arr)
  return 0 if arr.empty?
  s = arr.sort
  s[s.size / 2]
end

def dash_range(days_param)
  days  = DASH_RANGES.map(&:first).include?(days_param.to_s) ? days_param.to_i : 30
  today = digest_zone.now.to_date
  first = today - (days - 1)
  from  = digest_window(first).first
  {days: days, dates: (first..today).to_a, from: from, to: digest_zone.now, prev_from: from - days.days}
end

def dash_events(from, to, crit = {})
  crit = {created_at: {'$gte' => from.utc, '$lt' => to.utc}}.merge(crit)
  $page_events.find(crit, projection: {ip: 0, el_class: 0, el_id: 0}).to_a.each { |e| e['day'] = e['created_at'].in_time_zone(DIGEST_TZ).to_date }
end

## traffic classification

def traffic_source(landing)
  utm = (Rack::Utils.parse_query(landing['query'].to_s.sub(/\A\?/, ''))['utm_source'] rescue nil)
  (utm.presence || landing['ref_host']).to_s.downcase.presence
end

def traffic_channel(src)
  return 'Direct'        if src.nil?
  return 'AI assistants' if src =~ AI_SOURCES
  return 'Search'        if src =~ SEARCH_SOURCES
  return 'Social'        if src =~ SOCIAL_SOURCES
  return 'Email'         if src =~ EMAIL_SOURCES
  'Referral'
end

def ua_browser(ua)
  case ua.to_s
  when /LinkedInApp/            then 'LinkedIn app'
  when /FBAN|FBAV|FB_IAB/       then 'Facebook app'
  when /Instagram/              then 'Instagram app'
  when /Edg\//                  then 'Edge'
  when /OPR\/|Opera/            then 'Opera'
  when /SamsungBrowser/         then 'Samsung Internet'
  when /Firefox|FxiOS/          then 'Firefox'
  when /CriOS|Chrome/           then 'Chrome'
  when /Safari/                 then 'Safari'
  else 'Other'
  end
end

def ua_os(ua)
  case ua.to_s
  when /iPhone|iPad|iPod/       then 'iOS'
  when /Android/                then 'Android'
  when /CrOS/                   then 'ChromeOS'
  when /Mac OS X|Macintosh/     then 'macOS'
  when /Windows/                then 'Windows'
  when /Linux/                  then 'Linux'
  else 'Other'
  end
end

def ua_device(e)
  return 'Tablet' if e['ua'].to_s =~ /iPad|Tablet/
  e['mobile'] ? 'Mobile' : 'Desktop'
end

# Groups events into visits: per tab (sid), split on SESSION_TIMEOUT of inactivity.
def build_sessions(events)
  events.group_by { |e| e['sid'] || e['vid'] || e['_id'] }.values.flat_map { |evs|
    evs.sort_by { |e| e['created_at'] }.slice_when { |a, b| b['created_at'] - a['created_at'] > SESSION_TIMEOUT }.to_a
  }.map { |evs|
    views = evs.select { |e| e['type'] == 'pageview' }
    next if views.empty?
    landing = views.first
    src     = traffic_source(landing)
    {
      vid: landing['vid'], start: evs.first['created_at'], day: landing['day'],
      landing: landing['path'], paths: views.map { |e| e['path'] }, views: views.size,
      clicks: evs.count { |e| e['type'] == 'click' }, duration: evs.last['created_at'] - evs.first['created_at'],
      source: src, channel: traffic_channel(src), referrer: landing['referrer'],
      device: ua_device(landing), browser: ua_browser(landing['ua']), os: ua_os(landing['ua']),
      tz: landing['tz'], lang: landing['lang']
    }
  }.compact.sort_by { |s| s[:start] }.reverse
end

def daily_series(dates, views)
  by_day = views.group_by { |e| e['day'] }
  dates.map { |d| vs = by_day[d] || []; {date: d, views: vs.size, visitors: vs.map { |e| e['vid'] }.uniq.size} }
end

def engagement(sessions)
  {
    sessions:          sessions.size,
    pages_per_session: sessions.any? ? (sessions.sum { |s| s[:views] }.to_f / sessions.size).round(1) : 0,
    bounce_rate:       pct(sessions.count { |s| s[:views] == 1 && s[:clicks] == 0 }, sessions.size),
    median_duration:   median(sessions.map { |s| s[:duration] }.select(&:positive?))
  }
end

def returning_count(vids, before)
  return 0 if vids.empty?
  $page_events.distinct(:vid, vid: {'$in' => vids}, created_at: {'$lt' => before.utc}).size
end

def human_crit(from, to, extra = {})
  {type: 'pageview', bot: {'$ne' => true}, created_at: {'$gte' => from.utc, '$lt' => to.utc}}.merge(extra)
end

def dashboard_stats(range)
  bots, human = dash_events(range[:from], range[:to]).partition { |e| e['bot'] }
  views    = human.select { |e| e['type'] == 'pageview' }
  clicks   = human.select { |e| e['type'] == 'click' }
  sessions = build_sessions(human)
  vids     = views.map { |e| e['vid'] }.compact.uniq
  returning = returning_count(vids, range[:from])
  prev     = human_crit(range[:prev_from], range[:from])

  pages = views.group_by { |e| e['path'] }.map { |path, vs|
    entries = sessions.select { |s| s[:landing] == path }
    {path: path, views: vs.size, visitors: vs.map { |e| e['vid'] }.uniq.size, entrances: entries.size,
     bounce_rate: pct(entries.count { |s| s[:views] == 1 && s[:clicks] == 0 }, entries.size),
     daily: daily_series(range[:dates], vs)}
  }.sort_by { |p| -p[:views] }

  outbound = clicks.select { |e| e['href'].to_s =~ /\Ahttps?:/ && !e['href'].to_s.include?(e['host'].to_s.sub(/\Awww\./, '')) }

  {
    views: views.size, visitors: vids.size, returning: returning, new_visitors: vids.size - returning, clicks: clicks.size,
    prev_views: $page_events.count_documents(prev), prev_visitors: $page_events.distinct(:vid, prev).size,
    daily: daily_series(range[:dates], views), pages: pages, visit_list: sessions,
    channels:  count_top(sessions.map { |s| s[:channel] }),
    sources:   count_top(sessions.map { |s| s[:source] }, 15),
    ref_urls:  count_top(sessions.map { |s| s[:referrer] if s[:source] }, 15),
    devices:   count_top(sessions.map { |s| s[:device] }),
    browsers:  count_top(sessions.map { |s| s[:browser] }),
    os:        count_top(sessions.map { |s| s[:os] }),
    timezones: count_top(sessions.map { |s| s[:tz] }, 12),
    langs:     count_top(sessions.map { |s| s[:lang].to_s.split('-').first.presence }, 8),
    hours:     (0..23).map { |hr| [hr, views.count { |e| e['created_at'].in_time_zone(DIGEST_TZ).hour == hr }] },
    top_clicks: count_top(clicks.map { |e| [e['text'].presence || e['href'] || e['tag'], e['path']] }, 10),
    outbound:  count_top(outbound.map { |e| e['href'] }, 10),
    bots:      bots.size,
    bot_agents: count_top(bots.map { |e| e['ua'].to_s[0, 80].presence || '(no user agent)' }, 5)
  }.merge(engagement(sessions))
end

def page_stats(path, range)
  human    = dash_events(range[:from], range[:to], bot: {'$ne' => true})
  views    = human.select { |e| e['type'] == 'pageview' && e['path'] == path }
  sessions = build_sessions(human)
  entries  = sessions.select { |s| s[:landing] == path }
  vids     = views.map { |e| e['vid'] }.compact.uniq
  # previous/next page within the same visit
  came_from, went_to = [], []
  sessions.each { |s| s[:paths].each_cons(2) { |a, b| came_from << a if b == path && a != path; went_to << b if a == path && b != path } }

  {
    path: path, views: views.size, visitors: vids.size, entrances: entries.size,
    prev_views: $page_events.count_documents(human_crit(range[:prev_from], range[:from], path: path)),
    exits: sessions.count { |s| s[:paths].last == path },
    daily: daily_series(range[:dates], views),
    channels: count_top(entries.map { |s| s[:channel] }),
    sources:  count_top(entries.map { |s| s[:source] }, 12),
    ref_urls: count_top(entries.map { |s| s[:referrer] if s[:source] }, 12),
    came_from: count_top(came_from), went_to: count_top(went_to),
    clicks:   count_top(human.select { |e| e['type'] == 'click' && e['path'] == path }.map { |e| [e['text'].presence || e['href'] || e['tag'], e['href']] }, 15),
    devices:  count_top(views.map { |e| ua_device(e) }),
    timezones: count_top(views.map { |e| e['tz'] }, 8),
    first_seen: $page_events.find(type: 'pageview', path: path).sort(created_at: 1).limit(1).first&.dig('created_at'),
    all_time: $page_events.count_documents(type: 'pageview', path: path, bot: {'$ne' => true})
  }.merge(engagement(entries))
end

## routes

get '/admin/analytics' do
  redirect "/admin#{request.query_string.present? ? '?' + request.query_string : ''}"
end

get '/admin/page' do
  protected!
  halt 400, 'path required' unless pr[:path].present?
  @range = dash_range(pr[:days])
  @s     = page_stats(pr[:path], @range)
  layout(:'admin/analytics_page', "Analytics: #{pr[:path]}", page_class: 'admin', noindex: true)
end

def render_admin_dashboard
  protected!
  @range = dash_range(pr[:days])
  @s     = dashboard_stats(@range)
  layout(:'admin/analytics', 'Analytics', page_class: 'admin', noindex: true)
end

## rendering helpers (HTML + CSS charts; styles in public/css/site.css under "admin")

def nice_max(v)
  return 4 if v <= 4
  mag = 10 ** Math.log10(v).floor
  [1, 2, 2.5, 5, 10].map { |m| m * mag }.find { |m| m >= v }
end

def axis_num(v)
  v % 1 == 0 ? fmt_num(v) : v.round(1).to_s
end

# points: [[value, tooltip]]; xlabels: [[index, label]]
def col_chart(points, xlabels: [], spark: false, label: nil)
  max   = nice_max(points.map(&:first).max.to_f)
  dense = points.size > 60 ? ' dense' : ''
  bars  = points.map { |v, tip| "<div class='col' data-tip='#{h tip}'><i style='height:#{(v * 100.0 / max).round(2)}%'></i></div>" }.join
  return "<div class='spark#{dense}' role='img' aria-label='#{h label}'>#{bars}</div>" if spark

  grid = [max, max / 2.0].map { |v| "<span style='bottom:#{v * 100.0 / max}%'><b>#{axis_num(v)}</b></span>" }.join
  xs   = xlabels.map { |i, l| "<span style='left:#{((i + 0.5) * 100.0 / points.size).round(2)}%'>#{h l}</span>" }.join
  "<div class='cols#{dense}' role='img' aria-label='#{h label}'><div class='cols-plot'><div class='cols-grid'>#{grid}</div>" \
  "<div class='cols-bars'>#{bars}</div></div><div class='cols-x'>#{xs}</div></div>"
end

def daily_chart(daily, label)
  n   = daily.size
  pts = daily.map { |d| [d[:views], "#{d[:date].strftime('%a %b %-d')} · #{fmt_num d[:views]} views · #{fmt_num d[:visitors]} visitors"] }
  idx = n <= 7 ? (0...n).to_a : [0, n / 3, 2 * n / 3, n - 1]
  col_chart(pts, xlabels: idx.uniq.map { |i| [i, daily[i][:date].strftime('%b %-d')] }, label: label)
end

def spark_chart(daily)
  col_chart(daily.map { |d| [d[:views], "#{d[:date].strftime('%b %-d')}: #{d[:views]}"] }, spark: true, label: 'Views per day')
end

# rows: [[label, n]]; link: ->(label) { html } to render the label as a link
def bar_list(rows, total: nil, link: nil)
  return "<p class='empty'>No data yet.</p>" if rows.empty?
  max = rows.map(&:last).max.to_f
  items = rows.map { |label, n|
    lbl = link ? link.call(label) : h(label)
    "<li><span class='lbl'>#{lbl}</span><span class='num'>#{fmt_num n}#{total ? " <em>#{pct(n, total)}%</em>" : ''}</span>" \
    "<i style='width:#{(n / max * 100).round(1)}%'></i></li>"
  }
  "<ol class='barlist'>#{items.join}</ol>"
end

def delta_html(now, before)
  return "<span class='delta'>no earlier data</span>" if before.to_i == 0
  d = ((now - before) * 100.0 / before).round
  "<span class='delta'>#{d >= 0 ? '▲' : '▼'} #{d.abs}% vs previous #{@range[:days]} days</span>"
end

def kpi(label, value, sub = '')
  "<div class='kpi'><span class='kpi-l'>#{label}</span><b>#{value}</b><small>#{sub}</small></div>"
end

def admin_page_link(path, text = path)
  "<a href='/admin/page?path=#{CGI.escape(path.to_s)}&days=#{@range[:days]}'>#{h text}</a>"
end

def ext_link(url, text = url)
  url.to_s =~ /\Ahttps?:\/\// ? "<a href='#{h url}' target='_blank' rel='noopener noreferrer'>#{h text}</a>" : h(text)
end

def range_chips(extra = {})
  DASH_RANGES.map { |d, l|
    q = Rack::Utils.build_query(extra.merge(days: d))
    "<a class='chip' href='?#{h q}' aria-pressed='#{@range[:days].to_s == d}'>#{l}</a>"
  }.join
end
