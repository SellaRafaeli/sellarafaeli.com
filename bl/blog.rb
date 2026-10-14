# Blog + markdown pages.
#
# The blog index lives in views/blog/posts.yml; posts are views/blog/<slug>.md.
# Essays ("articles") are views/articles/<slug>.md and are listed by filename.

require 'yaml'
require 'cgi'

SITE_URL  = 'https://sellarafaeli.com'
SITE_NAME = 'Sella Rafaeli'

def read_utf8(path)
  File.read(path, encoding: 'UTF-8') # don't depend on the process locale (LANG)
end

# Rouge's non-deprecated formatter, wrapped in <div class=highlight><pre><code> like the legacy one.
class RougeBlockFormatter < Rouge::Formatters::HTMLPygments
  def initialize(_opts = {})
    super(Rouge::Formatters::HTML.new, 'highlight')
  end
end

def render_markdown(text)
  Kramdown::Document.new(text, input: 'GFM', syntax_highlighter: :rouge,
                         syntax_highlighter_opts: {formatter: RougeBlockFormatter}).to_html
end

# A safe path to views/<dir>/<slug>.md, or nil.
def content_file(dir, slug)
  return nil unless slug.to_s =~ /\A[\w,-]+\z/
  path = "views/#{dir}/#{slug}.md"
  File.file?(path) ? path : nil
end

# Splits a markdown post into [title, body]: drops legacy metadata
# (<!-- {"created_at": ...} --> and <span class='date'> lines) and pulls out a leading heading.
def split_post(text)
  lines = text.lines
  junk  = /\A\s*(<!--.*-->|<span class='date'>.*<\/span>)?\s*\z/
  lines.shift while lines.any? && lines.first =~ junk

  title = nil
  if lines[0] =~ /\A\#{1,3}\s*(.+?)\s*#*\s*\z/
    title = $1
    lines.shift
  elsif lines[1] =~ /\A(=+|-+)\s*\z/ && lines[0].to_s.strip != ''
    title = lines[0].strip
    lines.shift(2)
  end
  [title, lines.join]
end

def reading_minutes(text)
  [(text.split.size / 230.0).ceil, 1].max
end

def nice_date(date)
  date&.strftime('%-d %b %Y')
end

## Blog index

def blog_posts
  YAML.load_file('views/blog/posts.yml', permitted_classes: [Date]).map do |p|
    p = p.transform_keys(&:to_sym)
    p[:date] = Date.parse(p[:date].to_s) if p[:date]
    p[:href] = p[:slug] ? "/blog/#{p[:slug]}" : p[:url]
    p[:external] = !p[:slug]
    p[:source] = URI(p[:url]).host.to_s.split('.')[-2] if p[:url] # medium, wordpress, ...
    p
  end
end

def blog_posts_by_year
  blog_posts.group_by { |p| p[:date].year }.sort.reverse
end

# Renders a local blog post (or a draft that isn't in posts.yml) as a page.
def blog_post_page(slug)
  path = content_file('blog', slug) or raise Sinatra::NotFound
  posts = blog_posts
  local = posts.reject { |p| p[:external] }
  idx   = local.index { |p| p[:slug] == slug }
  meta  = idx ? local[idx] : {}

  heading, body = split_post(read_utf8(path))
  title = heading || meta[:title] || slug.tr('_-', '  ').capitalize

  html = erb :'blog/post', locals: {
    title: title, date: meta[:date], minutes: reading_minutes(body),
    body: render_markdown(body),
    newer: idx && idx > 0 ? local[idx - 1] : nil,
    older: idx ? local[idx + 1] : nil,
    back: ['/blog', 'All posts']
  }
  erb :template, locals: {content: html, basename: "blog/#{slug}", title: title,
                          page_class: 'post', description: meta[:title]}
end

## Essays

def essay_slugs
  Dir['views/articles/*.md'].map { |f| File.basename(f, '.md') }.sort
end

def essay_title(slug)
  heading, _ = split_post(read_utf8("views/articles/#{slug}.md"))
  heading || slug.tr('_', ' ').titleize
end

def essay_page(slug)
  path = content_file('articles', slug) or raise Sinatra::NotFound
  heading, body = split_post(read_utf8(path))
  title = heading || slug.tr('_', ' ').titleize

  html = erb :'blog/post', locals: {
    title: title, date: nil, minutes: reading_minutes(body),
    body: render_markdown(body), newer: nil, older: nil, back: ['/articles', 'All essays']
  }
  erb :template, locals: {content: html, basename: "articles/#{slug}", title: title, page_class: 'post essay'}
end

## Atom feed

def blog_feed_xml
  posts = blog_posts.first(30)
  esc   = ->(s) { CGI.escapeHTML(s.to_s) }
  ts    = ->(d) { d.to_time.utc.iso8601 }

  entries = posts.map do |p|
    url = p[:external] ? p[:url] : SITE_URL + p[:href]
    content = if (path = !p[:external] && content_file('blog', p[:slug]))
      "<content type=\"html\">#{esc.(render_markdown(split_post(read_utf8(path))[1]))}</content>"
    end
    <<~XML
      <entry>
        <title>#{esc.(p[:title])}</title>
        <link href="#{esc.(url)}"/>
        <id>#{esc.(url)}</id>
        <updated>#{ts.(p[:date])}</updated>
        #{content}
      </entry>
    XML
  end

  <<~XML
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <title>#{SITE_NAME}</title>
      <link href="#{SITE_URL}/blog"/>
      <link rel="self" href="#{SITE_URL}/blog/feed.xml"/>
      <id>#{SITE_URL}/blog</id>
      <updated>#{ts.(posts.first[:date])}</updated>
      <author><name>#{SITE_NAME}</name></author>
    #{entries.join}
    </feed>
  XML
end
