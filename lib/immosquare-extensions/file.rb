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
    ##============================================================##
    ## Get the file size
    ##============================================================##
    file_size = File.size?(file_path)

    ##============================================================##
    ## If the file is empty (0 bytes), there's nothing to normalize.
    ##============================================================##
    return 0 if file_size.nil? || file_size == 0


    end_of_line = $INPUT_RECORD_SEPARATOR || "\n"
    ##============================================================##
    ## Read all lines from the file
    ## https://gist.github.com/guilhermesimoes/d69e547884e556c3dc95
    ## Detect the encoding of the file using uchardet
    ## Read the content of the file with the detected encoding,
    ## falling back to UTF-8 if the detected encoding is empty or invalid.
    ##============================================================##
    detected_encoding  = `uchardet #{file_path}`.strip.to_s.upcase
    encoding_whitelist = [
      "UTF-8",            # Encodage universel pour texte avec ou sans accents
      "Windows-1252",     # Utilisé couramment pour les langues occidentales
      "ISO-8859-1",       # L'encodage Latin-1, très utilisé en Europe Occidentale
      "Windows-1250",     # Europe Centrale et Orientale
      "ISO-8859-2",       # Pour les langues d'Europe Centrale
      "Windows-1251",     # Cyrillic; utilisé pour le russe, bulgare, serbe cyrillique
      "KOI8-R",           # Russe
      "ISO-8859-5",       # Encodage cyrillique
      "ISO-8859-7",       # Grec
      "Windows-1253",     # Grec
      "ISO-8859-9",       # Turc
      "Windows-1254",     # Turc
      "ISO-8859-15",      # Variante de l'ISO-8859-1 qui couvre plus de caractères
      "Windows-1256",     # Arabe
      "ISO-8859-6",       # Arabe
      "Windows-1255",     # Hébreu
      "ISO-8859-8",       # Hébreu
      "Big5",             # Chinois traditionnel
      "GB2312",           # Chinois simplifié
      "Shift_JIS",        # Japonais
      "EUC-JP",           # Japonais
      "EUC-KR",           # Coréen
      "ISO-2022-JP",      # Encodage pour le courrier électronique en japonais
      "ISO-2022-KR",      # Coréen
      "ISO-2022-CN",      # Chinois
      "UTF-16LE",         # UTF-16 Little Endian
      "UTF-16BE",         # UTF-16 Big Endian
      "UTF-32LE",         # UTF-32 Little Endian
      "UTF-32BE"          # UTF-32 Big Endian
    ].map(&:upcase)



    encoding_to_use   = detected_encoding.empty? || !encoding_whitelist.include?(detected_encoding) ? "UTF-8" : "#{detected_encoding}:UTF-8"
    content           = File.read(file_path, :encoding => encoding_to_use)

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
    File.write(file_path, content, :encoding => encoding_to_use)

    ##===========================================================================##
    ## Return the total number of lines in the modified file
    ##===========================================================================##
    content.lines.size
  end

end
