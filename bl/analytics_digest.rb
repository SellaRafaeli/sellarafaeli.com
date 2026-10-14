## Daily analytics digest email, built from $page_events (see analytics.rb).

DIGEST_TO   = 'sella.rafaeli@gmail.com'
DIGEST_TZ   = 'Asia/Jerusalem'
DIGEST_HOUR = 8 # send at/after 08:00 Israel time, covering the previous day

$digest_log = $mongo.collection('analytics_digests') # one doc per sent day, doubles as a send-once lock

def digest_zone
  Time.find_zone(DIGEST_TZ)
end

def digest_window(day) # day: Date (in DIGEST_TZ)
  from = digest_zone.local(day.year, day.month, day.day)
  [from, from + 1.day]
end

def human_events(from, to)
  $page_events.find(created_at: {'$gte' => from.utc, '$lt' => to.utc}, bot: {'$ne' => true}).to_a
end

def count_top(items, n = 10)
  items.compact.hash_of_num_occurrences.first(n)
end

def pct_change(now, before)
  return '' if before.to_i == 0
  diff = ((now - before) * 100.0 / before).round
  diff >= 0 ? "+#{diff}%" : "#{diff}%"
end

def analytics_stats(day)
  from, to   = digest_window(day)
  events     = human_events(from, to)
  views      = events.select { |e| e['type'] == 'pageview' }
  clicks     = events.select { |e| e['type'] == 'click' }
  vids       = views.map { |e| e['vid'] }.compact.uniq
  returning  = vids.any? ? $page_events.distinct(:vid, vid: {'$in' => vids}, created_at: {'$lt' => from.utc}).size : 0
  prev_views = $page_events.count_documents(type: 'pageview', bot: {'$ne' => true}, created_at: {'$gte' => (from - 1.day).utc, '$lt' => from.utc})
  sessions   = views.group_by { |e| e['sid'] }.values

  trend = (0..6).map { |i|
    d = day - (6 - i)
    f, t = digest_window(d)
    [d, $page_events.count_documents(type: 'pageview', bot: {'$ne' => true}, created_at: {'$gte' => f.utc, '$lt' => t.utc})]
  }

  outbound = clicks.select { |e| e['href'].to_s =~ /\Ahttps?:/ && !e['href'].to_s.include?(e['host'].to_s.sub(/\Awww\./, '')) }

  {
    day:          day,
    pageviews:    views.size,
    prev_views:   prev_views,
    visitors:     vids.size,
    new_visitors: vids.size - returning,
    returning:    returning,
    sessions:     sessions.size,
    pages_per_session: sessions.any? ? (views.size.to_f / sessions.size).round(1) : 0,
    bounce_rate:  sessions.any? ? (sessions.count { |s| s.size == 1 } * 100.0 / sessions.size).round : 0,
    clicks:       clicks.size,
    mobile_pct:   views.any? ? (views.count { |e| e['mobile'] } * 100.0 / views.size).round : 0,
    bots:         $page_events.count_documents(bot: true, created_at: {'$gte' => from.utc, '$lt' => to.utc}),
    top_pages:    count_top(views.map { |e| e['path'] }),
    top_landing:  count_top(sessions.map { |s| s.min_by { |e| e['created_at'] }['path'] }, 5),
    referrers:    count_top(views.map { |e| e['ref_host'] }),
    top_clicks:   count_top(clicks.map { |e| [e['text'].presence || e['href'] || e['tag'], e['path']].join('  @ ') }),
    outbound:     count_top(outbound.map { |e| e['href'] }),
    hosts:        count_top(views.map { |e| e['host'] }, 5),
    trend:        trend,
    total_all_time: $page_events.count_documents(type: 'pageview', bot: {'$ne' => true})
  }
end

def digest_table(title, rows, total = nil)
  return '' if rows.empty?
  max = [rows.map(&:last).max.to_f, 1].max
  trs = rows.map { |label, n|
    bar = (n / max * 100).round
    "<tr><td style='padding:4px 8px 4px 0;font-size:13px;word-break:break-all'>#{CGI.escapeHTML(label.to_s)}</td>" \
    "<td style='padding:4px 0;width:120px'><div style='background:#2a7ab8;height:8px;width:#{bar}%;border-radius:2px'></div></td>" \
    "<td style='padding:4px 0 4px 8px;font-size:13px;text-align:right;white-space:nowrap'><b>#{n}</b>#{total.to_i > 0 ? " <span style='color:#888'>(#{(n * 100.0 / total).round}%)</span>" : ''}</td></tr>"
  }.join
  "<h3 style='margin:24px 0 6px;font-size:15px'>#{title}</h3><table style='width:100%;border-collapse:collapse'>#{trs}</table>"
end

def digest_html(s)
  tile = ->(label, val, sub = '') {
    "<td style='padding:10px;border:1px solid #e5e5e5;border-radius:6px;text-align:center'>" \
    "<div style='font-size:22px;font-weight:bold'>#{val}</div><div style='font-size:12px;color:#666'>#{label}</div>" \
    "<div style='font-size:11px;color:#888'>#{sub}</div></td>"
  }
  trend_rows = s[:trend].map { |d, n| [d.strftime('%a %b %-d'), n] }

  <<~HTML
    <div style="font-family:-apple-system,Segoe UI,Helvetica,Arial,sans-serif;max-width:640px;margin:0 auto;color:#222">
      <h2 style="margin:0 0 4px">sellarafaeli.com — #{s[:day].strftime('%A, %b %-d %Y')}</h2>
      <p style="margin:0 0 16px;color:#666;font-size:13px">Daily analytics digest (#{DIGEST_TZ}). Bots excluded (#{s[:bots]} bot hits filtered).</p>
      <table style="width:100%;border-collapse:separate;border-spacing:6px"><tr>
        #{tile.('page views', s[:pageviews], "#{pct_change(s[:pageviews], s[:prev_views])} vs. day before (#{s[:prev_views]})")}
        #{tile.('visitors', s[:visitors], "#{s[:new_visitors]} new · #{s[:returning]} returning")}
        #{tile.('sessions', s[:sessions], "#{s[:pages_per_session]} pages/session")}
      </tr><tr>
        #{tile.('clicks', s[:clicks])}
        #{tile.('bounce rate', "#{s[:bounce_rate]}%", 'single-page sessions')}
        #{tile.('mobile', "#{s[:mobile_pct]}%", 'of page views')}
      </tr></table>
      #{digest_table('Top pages', s[:top_pages], s[:pageviews])}
      #{digest_table('Landing pages', s[:top_landing], s[:sessions])}
      #{digest_table('Referrers', s[:referrers])}
      #{digest_table('Top clicks', s[:top_clicks])}
      #{digest_table('Outbound links', s[:outbound])}
      #{s[:hosts].size > 1 ? digest_table('Hosts', s[:hosts], s[:pageviews]) : ''}
      #{digest_table('Page views, last 7 days', trend_rows)}
      #{s[:pageviews] == 0 ? "<p style='color:#888'>No human page views recorded this day.</p>" : ''}
      <p style="margin-top:24px;color:#999;font-size:11px">#{s[:total_all_time]} page views recorded all-time · collection: page_events</p>
    </div>
  HTML
end

def yesterday_il
  digest_zone.now.to_date - 1
end

# Sends the digest for `day` once; the unique _id in $digest_log keeps restarts/multiple processes from double-sending.
def send_analytics_digest(day = yesterday_il, opts = {})
  key = day.to_s
  unless opts[:force]
    begin
      $digest_log.insert_one(_id: key, created_at: Time.now)
    rescue Mongo::Error::OperationFailure
      return {sent: false, msg: "digest for #{key} already sent"}
    end
  end
  s = analytics_stats(day)
  send_email(DIGEST_TO, "sellarafaeli.com: #{s[:pageviews]} views, #{s[:visitors]} visitors (#{day.strftime('%b %-d')})", digest_html(s))
  {sent: true, day: key, pageviews: s[:pageviews]}
rescue => e
  $digest_log.delete_one(_id: key) unless opts[:force] # allow a retry
  puts "analytics digest error: #{e}"
  {sent: false, error: e.to_s}
end

# Preview in the browser: /admin/digest?day=2026-10-13
get '/admin/digest' do
  protected!
  day = (Date.parse(pr[:day]) rescue yesterday_il)
  digest_html(analytics_stats(day))
end

# Manual / external-cron trigger: /admin/digest/send?day=2026-10-13&force=1
post '/admin/digest/send' do
  protected!
  day = (Date.parse(pr[:day]) rescue yesterday_il)
  send_analytics_digest(day, force: pr[:force].present?)
end

if $prod && !defined?($digest_scheduler)
  $digest_scheduler = Rufus::Scheduler.new
  # hourly check (not a single 08:00 cron) so a restart around send time can't skip a day; the lock dedupes
  $digest_scheduler.every('1h', first_in: '1m') { send_analytics_digest if digest_zone.now.hour >= DIGEST_HOUR }
end
