



###
# Page options, layouts, aliases and proxies
###
require 'redcarpet_helper'
# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

set :markdown_engine, :redcarpet
set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, with_toc_data: true, space_after_headers: true

###
# Helpers
###

helpers do
  def table_of_contents(resource)
    content = ""
    Dir.foreach('source/partials/chapters/') do |file| 
      next if file == '.' or file == '..'
      content = content + File.read("source/partials/chapters/#{file}")
    end
    toc_renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
    markdown = Redcarpet::Markdown.new(toc_renderer) # nesting_level is optional
    markdown.render(content)
  end

  def all_chapters()
    content = ""
    Dir.foreach('source/partials/chapters/') do |file| 
      next if file == '.' or file == '..'
      content = content + File.read("source/partials/chapters/#{file}")
    end
    chapters_renderer = Redcarpet::Render::HTML.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(chapters_renderer, :tables => true) 
    markdown.render(content)
    
  end

    
  def picture(file, alt)
    @html ="<img src='" + file.url + "' alt='" + alt + "'>"
    @html.html_safe
  end
    
    
end
# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# Build-specific configuration
configure :build do
  # Minify CSS on build
   activate :minify_css
set :relative_links, true
activate :relative_assets
  # Minify Javascript on build
   activate :minify_javascript
end
