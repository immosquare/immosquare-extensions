source "https://rubygems.org"

gemspec

group :development do
  gem "bundler"
  gem "immosquare-cleaner"
  gem "rake"
  ##============================================================##
  ## Language Server Protocol : https://shopify.github.io/ruby-lsp/
  ##============================================================##
  gem "ruby-lsp"
end

##============================================================##
## Anything the specs need belongs here and not in :development,
## which the CI skips (cf. bin/ci). activesupport is not dev
## comfort: the specs exercise the extensions against it.
##============================================================##
group :test do
  gem "activesupport"
  gem "rspec"
  gem "simplecov",      :require => false
  gem "simplecov-lcov", :require => false
end
