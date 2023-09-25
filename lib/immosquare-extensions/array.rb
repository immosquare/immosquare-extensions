##============================================================##
## This extension adds utility methods to the Array class.
##============================================================##
class Array

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

end
