require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  options = { 
    :assume_extension => true, 
    :typhoeus => {
      :ssl_verifypeer => false,
      :ssl_verifyhost => 0},
    :check_html => true,
    :empty_alt_ignore => true
  }
  HTMLProofer.check_directory("./_site", options).run
end
