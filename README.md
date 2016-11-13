# manuals-arturia
Tool to automatically build HTML / PDFs files from MarkDown

When working with various writers, you can have issues with their syntax, 
or their lack of respect of defined fonts, coding styles or writing styles. 
This tool uses a markdown syntax, with (at least) 6 files:
* index.html.erb
* _toc.erb
* _title.erb
* _thanks.erb
* _notice.erb
* chapters/a_chapter.erb

When you want to create a new manual, just add a folder corresponding to the 
product name in the source/partials folder, then create a chapters folder in 
this folder. 

## How to use this

With ruby installed (I believe >2.1.0 is mandatory, due to some libs), 
```
gem install bundler --install-dir vendor/bundle
bundle install --path vendor/bundle

# If you want a one-shot builder
bundle exec middleman build
# then go to build/partials/

# or if you want to auto-refresh your browser while changing your content
bundle exec middleman serve
# then go to http://127.0.0.1:4567/partials/yourproduct
```
