# immosquare Extensions

Enhance your Ruby experience with utility methods for standard classes like `Application Record`, `Array`, `File`, `Hash`, `String`, ...

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'immosquare-extensions'
```

Then execute:

```bash
$ bundle install
```

Or install it yourself:

```bash
$ gem install immosquare-extensions
```

## 1- Application Record Extensions (for Rails App)

`.dig` (This method allows you to access nested attributes of an ActiveRecord model without having to manually check if each level is nil. It will return the value of the last key if all keys are present, or nil if any key is missing.)

```ruby
user = User.first
user.dig(:profile, :card_type, :slug)         # => "some-slug"
user.dig(:profile, :non_existent_key, :slug)  # => nil
```


## 2- Array Extensions

`.mean` (Compute the average of numerical arrays.)

```ruby
[1, 2, 3, 4, 5].mean   # => 3.0
```

## 3- File Extensions

`.normalize_last_line` (Ensures that a file ends with a single newline character, facilitating cleaner multi-line blocks.)

```ruby
total_lines = File.normalize_last_line('path/to/your/file.csv')
puts "Total lines in the normalized file: #{total_lines}"
```

## 4- Hash Extensions

`.without` (Remove multiple keys in one command.)

```ruby
{a: 1, b: 2, c: 3}.without(:a, :b)  # => {:c=>3}
```


`.depth` (Determine the depth of a nested hash.)

```ruby
{a: {b: {c: 1}}}.depth  # => 3
```

`.sort_by_key` (Sort a hash by its keys, and optionally sort nested hashes recursively.)

```ruby
{b: 1, a: {d: 4, c: 3}}.sort_by_key  # => {:a=>{:c=>3, :d=>4}, :b=>1}
{b: 1, a: {d: 4, c: 3}}.sort_by_key(:recursive => false)  # => {:a=>{:d=>4, :c=>3}, :b=>1}
```

`.flatten_hash` (Flatten nested hashes into a single-level hash with dot notation.)

```ruby
{a: {b: {c: 1}}}.flatten_hash  # => {:a.b.c=>1}
```

`.to_beautiful_json` (Render the hash into a beautifully formatted JSON string, with options for alignment and indentation.)

**Options**:

- `:align` (default is `true`): Aligns the colons in key-value pairs for better readability.

- `:indent_size` (default is `2`): Specifies the number of spaces for each indentation level.

**Example**:

```ruby
hash_example = {
  name: "John",
  age: 30,
  address: {
    street: "123 Apple St",
    city: "FruitVille",
    postal_code: "12345"
  },
  is_student: false,
  courses: ["Math", "Science"]
}

puts hash_example.to_beautiful_json
```

**Output**:

```json
{
  "name":       "John",
  "age":        30,
  "address":    {
    "street":      "123 Apple St",
    "city":        "FruitVille",
    "postal_code": "12345"
  },
  "is_student": false,
  "courses":    [
    "Math",
    "Science"
  ]
}
```

**Disabling Alignment**:

```ruby
puts hash_example.to_beautiful_json(align: false)
```

**Output**:

```json
{
  "name": "John",
  "age": 30,
  "address": {
    "street": "123 Apple St",
    "city": "FruitVille",
    "postal_code": "12345"
  },
  "is_student": false,
  "courses": [
    "Math",
    "Science"
  ]
}
```


## 5 - String Extensions

`.to_boolean` (Convert strings like "true" and "false" to their boolean counterparts.)

```ruby
"true".to_boolean             # => true
"true".to_boolean("hello")    # => true
"false".to_boolean            # => false
"string".to_boolean           # => nil
"string".to_boolean("hello")  # => "hello"
```

`.titleize_custom` (Titleize strings while preserving hyphens, ideal for city names.)

```ruby
"SANT-ANDREA-D'ORCINO".titleize_custom  # => "Sant-Andrea-D'orcino"
```

`.upcase` (Upcase strings with proper Unicode handling.)

```ruby
"ä".upcase  # => "Ä"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/IMMOSQUARE/immosquare-extensions](https://github.com/IMMOSQUARE/immosquare-extensions). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
