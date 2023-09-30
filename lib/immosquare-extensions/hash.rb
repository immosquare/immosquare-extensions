##============================================================##
## This extension adds utility methods to the Hash class.
## It includes methods for handling and manipulating the keys
## and values of a hash in various ways.
##============================================================##
class Hash

  ##============================================================##
  ## Remove multiple keys from a hash in a single command.
  ##
  ## Reference:
  ## https://apidock.com/ruby/Hash/delete
  ##
  ## Examples:
  ## {a: 1, b: 2, c: 3}.without(:a, :b) => {:c=>3}
  ##============================================================##
  def without(*keys)
    cpy = dup
    keys.each {|key| cpy.delete(key) }
    cpy
  end

  ##============================================================##
  ## Calculate the depth (or level) of nesting within a hash.
  ##
  ## Example:
  ## {a: {b: {c: 1}}}.depth => 3
  ##============================================================##
  def depth
    return 0 unless any?

    1 + values.map {|v| v.is_a?(Hash) ? v.depth : 0 }.max
  end

  ##============================================================##
  ## Sort a hash by its keys. If the recursive flag is true,
  ## it will sort nested hashes as well.
  ## case-insensitive comparison and stripping of double quotes.
  ##
  ## Reference:
  ## http://dan.doezema.com/2012/04/recursively-sort-ruby-hash-by-key/
  ##
  ## Example:
  ## {b: 1, a: {d: 4, c: 3}}.sort_by_key(true) => {:a=>{:c=>3, :d=>4}, :b=>1}
  ##============================================================##
  def sort_by_key(recursive = false, &block)
    block ||= proc {|a, b| a.to_s.downcase.gsub("\"", "") <=> b.to_s.downcase.gsub("\"", "") }
    keys.sort(&block).each_with_object({}) do |key, seed|
      seed[key] = self[key]
      seed[key] = seed[key].sort_by_key(true, &block) if recursive && seed[key].is_a?(Hash)
    end
  end

  ##============================================================##
  ## Flatten a nested hash into a single-level hash. Nested keys
  ## are represented with dot notation.
  ##
  ## Reference:
  ## https://stackoverflow.com/questions/23521230/flattening-nested-hash-to-a-single-hash-with-ruby-rails
  ##
  ## Example:
  ## {a: {b: {c: 1}}}.flatten_hash => {:a.b.c=>1}
  ##============================================================##
  def flatten_hash
    each_with_object({}) do |(k, v), h|
      if v.is_a?(Hash)
        v.flatten_hash.map do |h_k, h_v|
          h["#{k}.#{h_k}".to_sym] = h_v
        end
      else
        h[k] = v
      end
    end
  end

  def to_beautiful_json
    dump_beautify_json(self, :align => true)
  end


  private

  def dump_beautify_json(hash, align: false, indent: 0)
    return hash.to_s unless hash.is_a?(Hash)

    space = " "
    indent_size = 2

    # Si l'alignement est demandé, nous trouvons la longueur maximale des clés à ce niveau.
    max_key_length = align ? hash.keys.map(&:to_s).map(&:length).max : 0

    # Génération du format JSON.
    json_parts = hash.map do |key, value|
      value_str = case value
                  when Hash
                    dump_beautify_json(value, :align => align, :indent => indent + indent_size)
                  else
                    value.to_s
                  end

      spacing = align ? space * (max_key_length - key.to_s.length + 1) : space

      "#{space * (indent + indent_size)}\"#{key}\":#{spacing}#{value_str}" # Augmenter l'indentation selon la taille d'indentation
    end

    "{\n#{json_parts.join(",\n")}\n#{space * indent}}"
  end








end
