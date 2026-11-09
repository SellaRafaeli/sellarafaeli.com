## Emails me whenever a request ends in a 500 (called from the `error do` handler in mw/error_handling.rb).
## On in production; set ERROR_ALERTS=1 to try it locally.

ERROR_ALERTS_TO       = 'sella.rafaeli@gmail.com'
ERROR_ALERTS_ON       = $prod || ENV['ERROR_ALERTS'].present?
ERROR_ALERT_COOLDOWN  = 5 * 60 # the same error emails at most once per 5 min; repeats are counted and reported in the next email
ERROR_ALERT_SECRET_RX = /pass|token|secret|key|auth|session|cookie|card|cvv|ssn/i

$error_alert_seen  = {} # signature => {last_sent:, suppressed:}
$error_alert_mutex = Mutex.new

def error_alert_signature(e)
  [e.class.name, e.message.to_s.gsub(/\d+/, 'N')[0, 200], e.backtrace.to_a.first].join('|')
end

# Returns nil if this error was emailed recently, else how many repeats were held back since the last email.
def error_alert_claim(sig)
  $error_alert_mutex.synchronize do
    now   = Time.now
    entry = $error_alert_seen[sig]
    if entry && now - entry[:last_sent] < ERROR_ALERT_COOLDOWN
      entry[:suppressed] += 1
      return nil
    end
    suppressed = entry ? entry[:suppressed] : 0
    $error_alert_seen[sig] = {last_sent: now, suppressed: 0}
    $error_alert_seen.shift while $error_alert_seen.size > 500
    suppressed
  end
end

def error_alert_params(params)
  params.to_h.each_with_object({}) do |(k, v), h|
    h[k] = k.to_s =~ ERROR_ALERT_SECRET_RX ? '[FILTERED]' : v.to_s[0, 500]
  end
rescue
  {}
end

# Grab what we need from the request now (it isn't safe to touch from another thread later).
def error_alert_details(e)
  req = request
  {
    time:       Time.now.in_time_zone('Asia/Jerusalem').strftime('%Y-%m-%d %H:%M:%S %Z'),
    error:      "#{e.class}: #{e.message}",
    backtrace:  e.backtrace.to_a.first(40),
    request:    "#{req.request_method} #{req.base_url}#{req.path}", # no query string: params are listed (filtered) below
    params:     error_alert_params(_params),
    ip:         (client_ip rescue req.ip),
    user_agent: req.user_agent,
    referer:    req.referer,
    user:       ([cuid, cusername].compact.join(' / ').presence rescue nil),
    request_id: req.env['HTTP_X_REQUEST_ID'],
  }
end

def error_alert_html(d, suppressed)
  esc  = ->(s) { Rack::Utils.escape_html(s.to_s) }
  rows = [
    ['When', d[:time]], ['Request', d[:request]], ['IP', d[:ip]], ['User', d[:user]],
    ['User agent', d[:user_agent]], ['Referer', d[:referer]], ['Request ID', d[:request_id]],
  ].reject { |_, v| v.blank? }
  td = "style='padding:4px 12px 4px 0;vertical-align:top'"
  <<~HTML
    <div style='font-family:-apple-system,Helvetica,Arial,sans-serif;font-size:14px;color:#222'>
      <h2 style='color:#b00020;margin:0 0 12px'>#{esc[d[:error]]}</h2>
      #{suppressed.to_i > 0 ? "<p><b>#{suppressed}</b> more of this error happened since the last email.</p>" : ''}
      <table>#{rows.map { |k, v| "<tr><td #{td}><b>#{k}</b></td><td #{td}>#{esc[v]}</td></tr>" }.join}</table>
      <h3>Params</h3>
      <pre style='background:#f5f5f5;padding:10px;white-space:pre-wrap'>#{esc[d[:params].present? ? JSON.pretty_generate(d[:params]) : '(none)']}</pre>
      <h3>Backtrace</h3>
      <pre style='background:#f5f5f5;padding:10px;font-size:12px;white-space:pre-wrap'>#{esc[d[:backtrace].join("\n")]}</pre>
    </div>
  HTML
end

# Never raises: a broken alert must not break the error page.
def send_error_alert(e)
  return unless ERROR_ALERTS_ON
  suppressed = error_alert_claim(error_alert_signature(e))
  return if suppressed.nil?
  d    = error_alert_details(e)
  subj = "[#{$app_name}] 500: #{d[:error]}"[0, 150]
  html = error_alert_html(d, suppressed)
  Thread.new do
    send_email(ERROR_ALERTS_TO, subj, html)
  rescue => err
    puts "error alert email failed: #{err}"
  end
rescue => err
  puts "error alert failed: #{err}"
end
