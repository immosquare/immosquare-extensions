# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

immosquare-extensions is a Ruby gem providing utility extensions for Ruby core classes (String, Hash, Array, File) and Rails ApplicationRecord. It extends standard classes with convenience methods for common operations.

## Common Commands

```bash
# Install dependencies
bundle install

# Run all tests
bundle exec rspec

# Run a specific test file
bundle exec rspec spec/string_spec.rb

# Run sample rake tasks (for development/testing)
bundle exec rake immosquare_extensions:sample:depth
bundle exec rake immosquare_extensions:sample:sort_by_key
bundle exec rake immosquare_extensions:sample:json
```

## Architecture

The gem is organized as class extensions that are automatically loaded:

- `lib/immosquare-extensions.rb` - Main entry point, loads all extensions
- `lib/immosquare-extensions/shared_methods.rb` - Private helper methods used by extensions (loaded first)
- `lib/immosquare-extensions/railtie.rb` - Rails integration, includes ApplicationRecord extensions into ActiveRecord::Base

### Extension Files

Each file in `lib/immosquare-extensions/` extends a Ruby core class:
- `string.rb` - String extensions (`to_boolean`, `titleize_custom` - requires ActiveSupport)
- `hash.rb` - Hash extensions (`without`, `depth`, `sort_by_key`, `flatten_hash`, `to_beautiful_json`)
- `array.rb` - Array extensions (`mean`, `to_beautiful_json`)
- `file.rb` - File extensions (`normalize_last_line`)
- `application_record.rb` - ActiveRecord `dig` method for nested attribute access

### Key Design Patterns

- Extensions add methods directly to Ruby core classes
- SharedMethods module provides `dump_beautify_json` helper for JSON formatting with alignment
- Rails integration via Railtie auto-loads ApplicationRecord extensions

## Dependencies

- Ruby >= 3.2.6
- ActiveSupport (optional, required for `titleize_custom` method)
