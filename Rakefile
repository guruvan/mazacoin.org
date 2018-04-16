require 'html-proofer'
# Lots of checks are disabled for pipeline development
# set check_html to true, 
# and remore ignores, 
# set report_* to true
# set empty_alt_ignore to true
task :test do
  sh "bundle exec jekyll build"
  options = { 
    :assume_extension => true,
    :check_html => false, 
    :validation => { 
      :report_script_embeds => false,
      :report_invalid_tags => false,
      :report_missing_names => false },
    :check_favicon => true,
    :url_ignore => [ 
      "/appstore/",
      "/panoramio/",
      "/theme/" ],
    :internal_domains => [ "mazacoin.org" ],
    :allow_hash_href => true,
    :empty_alt_ignore => true }
  HTMLProofer.check_directory("./_site", options).run
end
