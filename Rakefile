require 'html-proofer'
# Lots of checks are disabled for pipeline development
# set check_html => true, 
# and remore ignores, 
# set report_* => true
# set empty_alt_ignore => true
# set disable_external => false
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
    :disable_external => true,
    :url_ignore => [ 
      "/appstore/",
      "/panoramio/",
      "/theme/2014/11/24/starter-post-media-embed/",
      "/theme/" ],
    :internal_domains => [ "mazacoin.org" ],
    :allow_hash_href => true,
    :empty_alt_ignore => true }
  HTMLProofer.check_directory("./_site", options).run
end
