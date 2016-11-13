require 'action_view'
require 'multi_json'

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Reload the browser automatically
configure :development do
  activate :livereload
end

set :markdown_engine, :redcarpet
set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, with_toc_data: true, space_after_headers: true

helpers do
  class HTMLBlockCode < Redcarpet::Render::HTML
    include ActionView::Helpers::UrlHelper
    include MultiJson

    def image(link, title = nil, alt = nil)
      klass = nil

      begin
        multi_images = MultiJson.decode(link)
        output = %(<div class="row">)

        multi_images.each do |image|
          klass = image[1]['class'] || "col-xs-12"
          link = image[1]['link'] || nil
          title = image[1]['title'] || nil
          alt = image[1]['alt'] || nil
          output += image_tag(link, :title => title, :alt => alt, :klass => klass)
        end

        output += "</div>"
        %(#{output})
      rescue
          output = %(<div class="row">)
          
         output += image_tag(link, :title => title, :alt => alt, :klass => klass="col-xs-8 col-xs-offset-2")
      output += "</div>"
      %(#{output})
      end
    end

    def image_tag(link, options = {})
      %(
          <div class="#{options[:klass]} img-box">
            <img src="#{link}" alt="" title="#{options[:title]}" class="img-responsive" />
            <p>#{options[:alt]}</p>
          </div>
      )
    end
  end

  def table_of_contents(path)
    content = ""
    chapters_path = "source/#{File.dirname(path)}/chapters"
    if !Dir.exists? chapters_path
      puts "no chapter folder - skipping"
      markdown.render("")
    end
    Dir.foreach("#{chapters_path}") do |file|
      next if file == '.' or file == '..'
      content = content + File.read("#{chapters_path}/#{file}")
    end
    toc_renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
    markdown = Redcarpet::Markdown.new(toc_renderer) # nesting_level is optional
    markdown.render(content)
  end

  # This function gets a path, figure out the product sku from it,
  # then try and find the json data matching, in which it should find the title
  def get_title(path)
    product_sku = product_sku(path)
    json_file = "source/data/#{product_sku}.json"
    if !File.exists? "#{Dir.getwd}/#{json_file}"
      puts "no json data - skipping"
      return ""
    end

    file = File.read("source/data/#{product_sku}.json")
    begin
      product_json = MultiJson.decode(file)
      return product_json['title']
    rescue
      return ""
    end
  end

  def product_sku(path)
    path_array = path.split('/')
    return path_array[1] || ""
  end

  def all_chapters(path)
    content = ""
    chapters_path = "source/#{File.dirname(path)}/chapters"
    if !Dir.exists? chapters_path
      puts "no chapter folder - skipping"
      markdown.render("")
    end
    Dir.foreach("#{chapters_path}") do |file|
      next if file == '.' or file == '..'
      content = content + File.read("#{chapters_path}/#{file}")
    end
    chapters_renderer = HTMLBlockCode.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(chapters_renderer, :tables => true, :autolink => true)
    markdown.render(content)

  end

end

# Build-specific configuration
configure :build do
  activate :minify_css
  set :relative_links, true
  activate :relative_assets
  activate :minify_javascript
end
