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
  ## Convert all keys of the hash to lowercase.
  ## If a value is an array, it recursively processes the
  ## nested hash elements.
  ##
  ## Example:
  ## { "A" => { "B" => "value" } }.downcase_key => {"a"=>{"b"=>"value"}}
  ##============================================================##
  def downcase_key
    keys.each do |k|
      store(k.downcase, (v = delete(k)).is_a?(Array) ? v.map(&:downcase_key) : v)
    end
    self
  end

  ##============================================================##
  ## Calculate the depth (or level) of nesting within a hash.
  ##
  ## Example:
  ## {a: {b: {c: 1}}}.depth => 3
  ##============================================================##
  def depth
    1 + values.map {|v| v.is_a?(Hash) ? v.depth : 1 }.max
  end

  ##============================================================##
  ## Sort a hash by its keys. If the recursive flag is true,
  ## it will sort nested hashes as well.
  ##
  ## Reference:
  ## http://dan.doezema.com/2012/04/recursively-sort-ruby-hash-by-key/
  ##
  ## Example:
  ## {b: 1, a: {d: 4, c: 3}}.sort_by_key(true) => {:a=>{:c=>3, :d=>4}, :b=>1}
  ##============================================================##
  def sort_by_key(recursive = false, &block)
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

end
