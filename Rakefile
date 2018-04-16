require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  options = { 
    :assume_extension => true, 
    :typhoeus => { :ssl_verifypeer => false, :ssl_verifyhost => 0 },
    :check_html => true,
    :check_favicon => true,
    :files_ignore => [ "./_site/app/2015/01/07/geo-visualization-sandy-and-airports/index.html" ],
    :internal_domains => [ "mazacoin.org" ],
    :empty_alt_ignore => true }
  HTMLProofer.check_directory("./_site", options).run
end
