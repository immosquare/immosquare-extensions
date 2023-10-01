module ImmosquareExtensions
  module SharedMethods
    ##============================================================##
    ## Helper method to convert value based on its type
    ##============================================================##
    def json_representation(value, align, indent_size, indent)
      case value
      when Hash, Array           then dump_beautify_json(value, align, indent_size, indent + indent_size)
      when String                then "\"#{value}\""
      when NilClass              then "null"
      when TrueClass, FalseClass then value.to_s
      else value
      end
    end

    ##============================================================##
    ## Helper method to recursively convert a hash or an array to
    ## a beautifully formatted JSON string.
    ##
    ## It takes into consideration the alignment of key-value pairs
    ## and the indentation for nested structures.
    ##
    ## Usage:
    ## dump_beautify_json(input_hash, align, indent_size, indent)
    ##============================================================##
    def dump_beautify_json(hash, align, indent_size, indent = 0)
      space = " "

      if hash.is_a?(Hash)
        return "{}" if hash.empty?

        if hash.keys.count == 1 && indent > 0
          key, value = hash.first
          value_str = json_representation(value, align, indent_size, indent)
          return "{\"#{key}\": #{value_str}}"
        end

        max_key_length = align ? hash.keys.map(&:to_s).map(&:length).max : 0

        json_parts = hash.map do |key, value|
          value_str = json_representation(value, align, indent_size, indent)
          spacing   =
            if value.is_a?(Hash)
              space
            else
              align ? space * (max_key_length - key.to_s.length + 1) : space
            end
          "#{space * (indent + indent_size)}\"#{key}\":#{spacing}#{value_str}"
        end

        "{\n#{json_parts.join(",\n")}\n#{space * indent}}"
      elsif hash.is_a?(Array)
        return "[]" if hash.empty?

        if hash.length == 1 && !hash.first.is_a?(Hash)
          value_str = json_representation(hash.first, align, indent_size, indent)
          return "[#{value_str}]"
        end

        array_parts = hash.map do |value|
          "#{space * (indent + indent_size)}#{json_representation(value, align, indent_size, indent)}"
        end
        "[\n#{array_parts.join(",\n")}\n#{space * indent}]"
      end
    end
  end
end
