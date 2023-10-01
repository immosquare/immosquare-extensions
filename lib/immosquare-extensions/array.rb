require "immosqaure-extensions"

##============================================================##
## This extension adds utility methods to the Array class.
##============================================================##
class Array

  include ImmosquareExtensions

  ##============================================================##
  ## Calculate the average (mean) of an array of numbers.
  ## The mean is the sum of the numbers divided by the count.
  ##
  ## Reference:
  ## https://www.chrisjmendez.com/2018/10/14/mean-median-mode-standard-deviation/
  ##
  ## Examples:
  ## [1, 2, 3, 4, 5].mean => 3.0
  ## [2, 4, 6].mean       => 4.0
  ##============================================================##
  def mean
    sum(0.0) / size
  end

  ##============================================================##
  ## A json file can be a hash or an array. This method will
  ## test.json
  ## [
  ##  {"name": "Alice"},
  ##  {"name": "Bob"},
  ##   123,
  ##  "string"
  ## ]
  ##============================================================##
  def to_beautiful_json(**options)
    options               = {}.merge(options)
    options[:align]       = true if ![true, false].include?(options[:align])
    options[:indent_size] = 2    if options[:indent_size].to_i == 0 || options[:indent_size].to_i > 10

    dump_beautify_json(self, options[:align], options[:indent_size])
  end


end
