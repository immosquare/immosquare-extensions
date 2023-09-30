# IMMO SQUARE Extensions

Enhance your Ruby experience with utility methods for standard classes like `String`, `Array`, and `Hash`.

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

## String Extensions

`.to_boolean` (Convert strings like "true" and "false" to their boolean counterparts.)

```ruby
"true".to_boolean   # => true
"false".to_boolean  # => false
"string".to_boolean # => nil
```

`.titleize_custom` (Titleize strings while preserving hyphens, ideal for city names.)

```ruby
"SANT-ANDREA-D'ORCINO".titleize_custom  # => "Sant-Andrea-D'orcino"
```

`.upcase` (Upcase strings with proper Unicode handling.)

```ruby
"ä".upcase  # => "Ä"
```

## Array Extensions

`.mean` (Compute the average of numerical arrays.)

```ruby
[1, 2, 3, 4, 5].mean   # => 3.0
```

## Hash Extensions

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
{b: 1, a: {d: 4, c: 3}}.sort_by_key(:recursive => true)  # => {:a=>{:c=>3, :d=>4}, :b=>1}
```

`.flatten_hash` (Flatten nested hashes into a single-level hash with dot notation.)

```ruby
{a: {b: {c: 1}}}.flatten_hash  # => {:a.b.c=>1}
```


...

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


## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/IMMOSQUARE/immosquare-extensions](https://github.com/IMMOSQUARE/immosquare-extensions). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
