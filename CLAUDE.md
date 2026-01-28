# immosquare-extensions

Ruby gem providing utility extensions for core classes (String, Hash, Array, File) and Rails ApplicationRecord.

## Commands

```bash
bundle install        # Install dependencies
bundle exec rspec     # Run tests
```

## Structure

| File | Class | Methods |
|------|-------|---------|
| `string.rb` | String | `to_boolean`, `titleize_custom`* |
| `hash.rb` | Hash | `without`, `depth`, `sort_by_key`, `flatten_hash`, `to_beautiful_json` |
| `array.rb` | Array | `mean`, `to_beautiful_json` |
| `file.rb` | File | `normalize_last_line` |
| `application_record.rb` | ActiveRecord | `dig` (nested attribute access) |

*`titleize_custom` requires ActiveSupport

**Other files:**
- `shared_methods.rb` - Internal helpers (`dump_beautify_json`)
- `railtie.rb` - Auto-loads ApplicationRecord extensions in Rails
