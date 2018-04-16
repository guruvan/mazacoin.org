require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  options = { 
    :assume_extension => true,
    :check_html => true,
    :check_favicon => true,
    :url_ignore => [ "/appstore/" ],
    :internal_domains => [ "mazacoin.org" ],
    :empty_alt_ignore => true }
  HTMLProofer.check_directory("./_site", options).run
end
