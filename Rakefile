require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  options = { 
    :assume_extension => true,
    :check_html => true,
    :check_favicon => true,
    :url_ignore => [ 
      "/appstore/",
      "/panoramio/",
      "https://mazacoin.org/ipfs/QmeFphaDUMjMhqih5w54g5mvqKzNMibPJJ8DNehhWtaVME",
      "https://www.coingather.com/exchange/MZC/BTC" ],
    :file_ignore => [ "/embeds/index.html" ],
    :internal_domains => [ "mazacoin.org" ],
    :allow_hash_href => true,
    :empty_alt_ignore => true }
  HTMLProofer.check_directory("./_site", options).run
end
