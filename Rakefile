require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  options = { 
    :assume_extension => true,
    :check_html => true, 
    :validation => { 
      :report_script_embeds => false,
      :report_invalid_tags => false,
      :report_missing_names => false },
    :check_favicon => true,
    :url_ignore => [ 
      "/appstore/",
      "/panoramio/",
      "/theme",
      "/ipfs/QmeFphaDUMjMhqih5w54g5mvqKzNMibPJJ8DNehhWtaVME",
      "/exchange/MZC/BTC" ],
    :internal_domains => [ "mazacoin.org" ],
    :allow_hash_href => true,
    :empty_alt_ignore => true }
  HTMLProofer.check_directory("./_site", options).run
end
