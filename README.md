# immosquare-extensions

Utility extensions for Ruby core classes (`String`, `Hash`, `Array`, `File`) and Rails `ApplicationRecord`.

## Table of Contents

- [Installation](#installation)
- [String Extensions](#string-extensions)
- [Hash Extensions](#hash-extensions)
- [Array Extensions](#array-extensions)
- [File Extensions](#file-extensions)
- [ApplicationRecord Extensions](#applicationrecord-extensions-rails)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add to your Gemfile:

```ruby
gem "immosquare-extensions"
```

Then run:

```bash
bundle install
```

Or install directly:

```bash
gem install immosquare-extensions
```

## String Extensions

### to_boolean

Converts `"true"` and `"false"` strings to boolean values. Returns `nil` (or a default value) for other strings.

```ruby
"true".to_boolean   # => true
"false".to_boolean  # => false
"TRUE".to_boolean   # => true (case-insensitive)
"other".to_boolean  # => nil

# With default value
"other".to_boolean(true)      # => true
"other".to_boolean("default") # => "default"
```

### titleize_custom

Titleizes strings while preserving hyphens. Useful for city names and hyphenated words.

**Note:** Requires ActiveSupport (available in Rails applications).

```ruby
"SANT-ANDREA-D'ORCINO".titleize_custom  # => "Sant-Andrea-D'orcino"
"jean-pierre".titleize_custom           # => "Jean-Pierre"
"hello world".titleize_custom           # => "Hello World"
```

## Hash Extensions

### without

Removes multiple keys from a hash in a single operation.

```ruby
{a: 1, b: 2, c: 3}.without(:a, :b)  # => {c: 3}
{a: 1, b: 2}.without(:x)            # => {a: 1, b: 2} (non-existent keys ignored)
```

### depth

Returns the nesting depth of a hash.

```ruby
{a: 1}.depth              # => 1
{a: {b: 1}}.depth         # => 2
{a: {b: {c: 1}}}.depth    # => 3
{}.depth                  # => 0
```

### sort_by_key

Sorts a hash by its keys. Optionally sorts nested hashes recursively. Sorting is case-insensitive.

```ruby
{b: 1, a: 2}.sort_by_key
# => {a: 2, b: 1}

{b: 1, a: {d: 4, c: 3}}.sort_by_key
# => {a: {c: 3, d: 4}, b: 1}

# Without recursion
{b: 1, a: {d: 4, c: 3}}.sort_by_key(recursive: false)
# => {a: {d: 4, c: 3}, b: 1}

# With custom sorting block
{b: 1, a: 2, c: 3}.sort_by_key { |x, y| y <=> x }
# => {c: 3, b: 1, a: 2}
```

### flatten_hash

Flattens a nested hash into a single-level hash with dot notation keys.

```ruby
{a: {b: {c: 1}}}.flatten_hash
# => {:"a.b.c" => 1}

{a: 1, b: {c: 2, d: 3}}.flatten_hash
# => {a: 1, :"b.c" => 2, :"b.d" => 3}
```

### to_beautiful_json (Hash)

Renders the hash as a formatted JSON string with aligned colons and customizable indentation.

**Options:**

| Option        | Default   | Description                            |
| ------------- | --------- | -------------------------------------- |
| `align`       | `true`    | Aligns colons in key-value pairs       |
| `indent_size` | `2`       | Number of spaces per indentation level |

```ruby
hash = {
  name: "John",
  age: 30,
  address: {
    street: "123 Apple St",
    city: "FruitVille"
  },
  active: true,
  scores: [85, 90, 78]
}

puts hash.to_beautiful_json
```

**Output (aligned):**

```json
{
  "name":    "John",
  "age":     30,
  "address": {
    "street": "123 Apple St",
    "city":   "FruitVille"
  },
  "active":  true,
  "scores":  [
    85,
    90,
    78
  ]
}
```

**Without alignment:**

```ruby
puts hash.to_beautiful_json(align: false)
```

```json
{
  "name": "John",
  "age": 30,
  "address": {
    "street": "123 Apple St",
    "city": "FruitVille"
  },
  "active": true,
  "scores": [
    85,
    90,
    78
  ]
}
```

## Array Extensions

### mean

Calculates the arithmetic mean (average) of numerical arrays.

```ruby
[1, 2, 3, 4, 5].mean  # => 3.0
[2, 4, 6].mean        # => 4.0
[10].mean             # => 10.0
[].mean               # => NaN (division by zero)
```

### to_beautiful_json (Array)

Renders the array as a formatted JSON string, with the same options as `Hash#to_beautiful_json`.

```ruby
data = [
  {name: "Alice", age: 25},
  {name: "Bob", age: 30}
]

puts data.to_beautiful_json
```

**Output:**

```json
[
  {
    "name": "Alice",
    "age":  25
  },
  {
    "name": "Bob",
    "age":  30
  }
]
```

## File Extensions

### normalize_last_line

Ensures a file ends with exactly one newline character. Removes trailing empty lines and adds a newline if missing. Returns the total number of lines.

```ruby
# File content: "line1\nline2\nline3" (no trailing newline)
File.normalize_last_line("path/to/file.txt")
# File content becomes: "line1\nline2\nline3\n"
# => 3

# File content: "line1\nline2\n\n\n" (multiple trailing newlines)
File.normalize_last_line("path/to/file.txt")
# File content becomes: "line1\nline2\n"
# => 2
```

## ApplicationRecord Extensions (Rails)

These extensions are automatically included in `ActiveRecord::Base` when using Rails.

### dig

Accesses nested attributes on ActiveRecord models without manual nil checks. Returns `nil` if any intermediate value is missing.

```ruby
user = User.first

# Instead of:
user.profile&.card_type&.slug

# You can write:
user.dig(:profile, :card_type, :slug)  # => "premium"
user.dig(:profile, :missing, :slug)    # => nil
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/immosquare/immosquare-extensions](https://github.com/immosquare/immosquare-extensions).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
