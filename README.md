---
locale: en
tags:
  - app:immosquare-extensions
  - audience:technique
---

# immosquare-extensions

`immosquare-extensions` is a Ruby gem that adds utility methods to the core classes `String`, `Hash`, `Array` and `File`, plus a nested-attribute accessor on Rails `ApplicationRecord`. This README is for Ruby and Rails developers using the gem: it covers installation, every method added class by class, and how to run the test suite and the CI entry point. It assumes Ruby `>= 3.2.6`; `String#titleize_place` and `String#titleize_name` additionally need ActiveSupport and `File.normalize_last_line` the `uchardet` CLI binary.

- [Installing immosquare-extensions](#installing-immosquare-extensions)
- [String extensions](#string-extensions-to_boolean-titleize_place-and-titleize_name)
- [Hash extensions](#hash-extensions-without-depth-sort_by_key-flatten_hash-and-to_beautiful_json)
- [Array extensions](#array-extensions-mean-and-to_beautiful_json)
- [File extensions](#file-extensions-normalize_last_line)
- [ApplicationRecord extensions](#applicationrecord-extensions-in-rails-dig)
- [Developing immosquare-extensions](#developing-immosquare-extensions-test-suite-coverage-and-ci)
- [Contributing and license](#contributing-to-immosquare-extensions-and-license)

## Installing immosquare-extensions

Add this line to your Gemfile:

```ruby
gem "immosquare-extensions"
```

Then run:

```bash
bundle install
```

Requires Ruby `>= 3.2.6`. `File.normalize_last_line` additionally requires the `uchardet` CLI binary (`brew install uchardet`) for encoding detection.

## String extensions: `to_boolean`, `titleize_place` and `titleize_name`

`immosquare-extensions` adds three methods to `String`.

**`String#to_boolean`** converts `"true"` and `"false"` strings to boolean values. Returns `nil` (or a default value) for other strings.

```ruby
"true".to_boolean   # => true
"false".to_boolean  # => false
"TRUE".to_boolean   # => true (case-insensitive)
"other".to_boolean  # => nil

# With default value
"other".to_boolean(true)      # => true
"other".to_boolean("default") # => "default"
```

**`String#titleize_place`** titleizes a place name under French typographic rules, which standard `titleize` gets wrong: hyphens are preserved, the capital goes on the letter *after* an apostrophe, and particles (`de`, `du`, `des`, `la`, `le`, `les`, `sur`, `en`, `ès`, `à`, `au`, `aux`, `et`, `sous`, `lès`) stay lowercase unless they open the name. An English possessive is left alone. It requires ActiveSupport (available in Rails applications).

```ruby
"SANT-ANDREA-D'ORCINO".titleize_place      # => "Sant-Andrea-d'Orcino"
"saint-jean-sur-richelieu".titleize_place  # => "Saint-Jean-sur-Richelieu"
"l'assomption".titleize_place              # => "L'Assomption"
"MONTRÉAL".titleize_place                  # => "Montréal"
"st john's".titleize_place                 # => "St John's"
"hello world".titleize_place               # => "Hello World"
```

**`String#titleize_name`** titleizes anything that is not a place — a person, an agency, a building, an enumeration label. Same apostrophe and accent handling as `titleize_place`, but no particle is lowercased.

```ruby
"o'brien".titleize_name          # => "O'Brien"
"MAISON DE VILLE".titleize_name  # => "Maison De Ville"
"émilie".titleize_name           # => "Émilie"
```

Both methods normalize through ActiveSupport's `humanize` first, which has three known consequences: internal capitals are flattened (`MacDonald` → `Macdonald`), a dotted abbreviation reads as a particle (`n.-d.-de-grâce` → `N.-d.-de-Grâce`) and roman numerals are recapitalized (`Louis XIV` → `Louis Xiv`).

> `titleize_place` and `titleize_name` replace `titleize_custom`, removed in `0.2.0`. `titleize_custom` capitalized the letter *before* the apostrophe and lowered no particle, so `"SANT-ANDREA-D'ORCINO"` came out as `"Sant-Andrea-D'orcino"`.

## Hash extensions: `without`, `depth`, `sort_by_key`, `flatten_hash` and `to_beautiful_json`

`immosquare-extensions` adds five methods to `Hash`.

**`Hash#without`** removes multiple keys from a hash in a single operation.

```ruby
{a: 1, b: 2, c: 3}.without(:a, :b)  # => {c: 3}
{a: 1, b: 2}.without(:x)            # => {a: 1, b: 2} (non-existent keys ignored)
```

**`Hash#depth`** returns the nesting depth of a hash.

```ruby
{a: 1}.depth              # => 1
{a: {b: 1}}.depth         # => 2
{a: {b: {c: 1}}}.depth    # => 3
{}.depth                  # => 0
```

**`Hash#sort_by_key`** sorts a hash by its keys. Optionally sorts nested hashes recursively. Sorting is case-insensitive.

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

**`Hash#flatten_hash`** flattens a nested hash into a single-level hash with dot notation keys.

```ruby
{a: {b: {c: 1}}}.flatten_hash
# => {:"a.b.c" => 1}

{a: 1, b: {c: 2, d: 3}}.flatten_hash
# => {a: 1, :"b.c" => 2, :"b.d" => 3}
```

**`Hash#to_beautiful_json`** renders the hash as a formatted JSON string with aligned colons and customizable indentation. Its two options, with their default values and what each one controls:

| Option        | Default   | Description                                                                                  |
| ------------- | --------- | -------------------------------------------------------------------------------------------- |
| `align`       | `true`    | Aligns colons in key-value pairs                                                             |
| `indent_size` | `2`       | Number of spaces per indentation level. Values `<= 0` or `> 10` fall back to the default `2` |

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

## Array extensions: `mean` and `to_beautiful_json`

`immosquare-extensions` adds two methods to `Array`.

**`Array#mean`** calculates the arithmetic mean (average) of numerical arrays.

```ruby
[1, 2, 3, 4, 5].mean  # => 3.0
[2, 4, 6].mean        # => 4.0
[10].mean             # => 10.0
[].mean               # => NaN (division by zero)
```

**`Array#to_beautiful_json`** renders the array as a formatted JSON string, with the same options as `Hash#to_beautiful_json`.

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

## File extensions: `normalize_last_line`

`File.normalize_last_line` ensures a file ends with exactly one newline character. Removes trailing empty lines and adds a newline if missing. Returns the total number of lines (or `0` if the file is empty).

The file encoding is auto-detected via the `uchardet` CLI binary and preserved on write. Detected encodings outside a known whitelist (UTF-8/16/32, Windows-125x, ISO-8859-x, KOI8-R, Big5, GB2312, Shift_JIS, EUC-JP/KR, ISO-2022-JP/KR/CN) fall back to UTF-8. File paths containing spaces are supported.

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

## ApplicationRecord extensions in Rails: `dig`

The `ApplicationRecord` extensions of `immosquare-extensions` are automatically included in `ActiveRecord::Base` when using Rails.

**`dig`** accesses nested attributes on ActiveRecord models without manual nil checks. Returns `nil` if any intermediate value is missing.

```ruby
user = User.first

# Instead of:
user.profile&.card_type&.slug

# You can write:
user.dig(:profile, :card_type, :slug)  # => "premium"
user.dig(:profile, :missing, :slug)    # => nil
```

## Developing immosquare-extensions: test suite, coverage and CI

To work on `immosquare-extensions` itself, install the dependencies and run the suite:

```bash
bundle install
bundle exec rspec
```

Set `COVERAGE=true` to measure coverage. Without it, `spec/coverage_helper.rb` is a no-op: the run stays fast and leaves no `coverage/` directory behind.

```bash
COVERAGE=true bundle exec rspec
```

Coverage is written to `coverage/` in two formats — an HTML report and `coverage/lcov.info`, which is the file the CI reads.

`bin/ci` is the entry point used by the Jenkins pipeline, and it works the same on a laptop. Each row below is one of its subcommands and what it runs:

| Command         | What it does                                                       |
| --------------- | ------------------------------------------------------------------ |
| `bin/ci init`   | Installs the bundle without the `development` group                |
| `bin/ci test`   | Runs `bundle exec rspec`                                           |

Everything specific to the build agent — RVM provisioning of the Ruby pinned in `.ruby-version`, bundler pinning — is skipped when `JENKINS_WORKSPACE` is unset.

Dependencies the specs need go in the `test` group of the Gemfile, never in `development`: the CI exports `BUNDLE_WITHOUT="development"` and a gem placed there is missing at test time.

## Contributing to immosquare-extensions and license

Bug reports and pull requests are welcome on GitHub at [https://github.com/immosquare/immosquare-extensions](https://github.com/immosquare/immosquare-extensions).

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
