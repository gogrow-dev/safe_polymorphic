# SafePolymorphic
[![Gem Version](https://badge.fury.io/rb/safe_polymorphic.svg)](https://badge.fury.io/rb/safe_polymorphic)
[![Ruby](https://github.com/gogrow-dev/safe_polymorphic/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/gogrow-dev/safe_polymorphic/actions/workflows/main.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/1b0a4b92bbee2be50dc1/maintainability)](https://codeclimate.com/github/gogrow-dev/safe_polymorphic/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1b0a4b92bbee2be50dc1/test_coverage)](https://codeclimate.com/github/gogrow-dev/safe_polymorphic/test_coverage)

An ActiveRecord extension which allows us to safely use polymorphic associations, by validating which classes are allowed to be related to, while also adding some helper methods.

The base idea was taken from this blogpost: [Improve ActiveRecord Polymorphic Associations - Head of engineering at Product Hunt](https://blog.rstankov.com/allowed-class-names-in-activerecord-polymorphic-associations/).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add safe_polymorphic

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install safe_polymorphic

## Usage

In your model you can do the following:

```ruby
class Book < ActiveRecord::Base
    belongs_to :owner, polymorphic: [User, Publisher]
end
```

Define a `belongs_to` relatinoship and instead of just adding the option `polymorphic: true`, we are able to specify the allowed polymorphic classes.

By using this, we will create a polymorphic relationship in `Book` called `owner` which can only be a `User` or a `Publisher`.
If we try to set an `owner` from a class rather than the aforementioend ones, it will return the following error:
```ruby
#ActiveRecord::RecordInvalid: Validation failed: Owner type OtherThing class is not an allowed class.
```

### Usage with namespaced models

```ruby
class Book < ActiveRecord::Base
    belongs_to :owner, polymorphic: [Publisher::User, Publisher]
end
```

### Helper methods

Class methods:
- `Book.owner_types`: returns the allowed classes
- `Book.with_owner(#{type})`: generic finder method
- `Book.with_owner_#{allowed_class_name}`: scope for each allowed class

Instance methods:
-  `book.owner_type_#{allowed_class_name}?`: check if it is from that specific class

### Helper methods with namespaced models

Class methods:
- `Book.with_owner(Publisher::User)`
- `Book.with_owner_publisher_user`
- `book.owner_type_publisher_user?`

## I18n

Safe Polymoprhic uses I18n to define the not allowed class error. To customize it, you can set up your locale file:

```yaml
en:
  safe_polymoprhic:
    errors:
      messages:
        class_not_allowed: "%{class} is not an allowed class"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/safe_polymorphic. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/safe_polymorphic/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the SafePolymorphic project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/safe_polymorphic/blob/main/CODE_OF_CONDUCT.md).

## Credits

belongs_to_polymorphic is maintained by [GoGrow](https://gogrow.dev) with the help of our
[contributors](https://github.com/gogrow-dev/belongs_to_polymorphic/contributors).

[<img src="https://user-images.githubusercontent.com/9309458/180014465-00477428-fd76-48f6-b984-5b401b8ce241.svg" height="50"/>](https://gogrow.dev)