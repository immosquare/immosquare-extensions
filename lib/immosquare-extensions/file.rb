class File

  ##===========================================================================##
  ## This method ensures the file ends with a single newline, facilitating
  ## cleaner multi-line blocks. It operates by reading all lines of the file,
  ## removing any empty lines at the end, and then appending a newline.
  ## This guarantees the presence of a newline at the end, and also prevents
  ## multiple newlines from being present at the end.
  ##
  ## Params:
  ## +file_path+:: The path to the file to be normalized.
  ##
  ## Returns:
  ## The total number of lines in the normalized file.
  ##===========================================================================##
  def self.normalize_last_line(file_path)
    end_of_line = $INPUT_RECORD_SEPARATOR || "\n"
    ##============================================================##
    ## Read all lines from the file
    ## https://gist.github.com/guilhermesimoes/d69e547884e556c3dc95
    ##============================================================##
    content = File.read(file_path)

    ##===========================================================================##
    ## Remove all trailing empty lines at the end of the file
    ##===========================================================================##
    content.gsub!(/#{Regexp.escape(end_of_line)}+\z/, "")

    ##===========================================================================##
    ## Append an EOL at the end to maintain the file structure
    ##===========================================================================##
    content << end_of_line

    ##===========================================================================##
    ## Write the modified lines back to the file
    ##===========================================================================##
    File.write(file_path, content)

    ##===========================================================================##
    ## Return the total number of lines in the modified file
    ##===========================================================================##
    content.lines.size
  end

end
