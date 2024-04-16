[![Gem Version](https://badge.fury.io/rb/safe_polymorphic.svg)](https://badge.fury.io/rb/safe_polymorphic.svg)
[![Ruby](https://github.com/gogrow-dev/safe_polymorphic/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/gogrow-dev/safe_polymorphic/actions/workflows/main.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/1b0a4b92bbee2be50dc1/maintainability)](https://codeclimate.com/github/gogrow-dev/safe_polymorphic/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1b0a4b92bbee2be50dc1/test_coverage)](https://codeclimate.com/github/gogrow-dev/safe_polymorphic/test_coverage)

# SafePolymorphic

> The best way to keep your polymorphic relationships safe.

<img align="right" width="150" title="SafePolymorphic logo" src="./logo.png">

An ActiveRecord extension for polymorphic associations.

* **Simple.** It is as easy to use as it is to update.
* **Safe.** It helps you avoid unintended usage of polymorphic classes.
* **Powerful.** It packages some helpful scopes and helper methods.

<a href="https://gogrow.dev/?utm_source=github&utm_content=safe_polymorphic">
<img src="https://www.gogrow.dev/_next/static/media/gogrow-logo.96254aba.svg" alt="Built by GoGrow" width="230"></a>


> Credits: [Improve ActiveRecord Polymorphic Associations](https://blog.rstankov.com/allowed-class-names-in-activerecord-polymorphic-associations/).

## Install

Install the gem and add to the application's Gemfile by executing:

    $ bundle add safe_polymorphic

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install safe_polymorphic

## Usage

In your model you can do the following:

```ruby
class Address < ActiveRecord::Base
    belongs_to :addressabel, polymorphic: [User, Company]
end
```

Define a `belongs_to` relatinoship and instead of just adding the option `polymorphic: true`, we are able to specify the allowed polymorphic classes.

By using this, we will create a polymorphic relationship in `Address` called `addressable` which can only be a `User` or a `Company`.
If we try to set an `addressable` from a class rather than the aforementioend ones, it will return the following error:
```ruby
#ActiveRecord::RecordInvalid: Validation failed: Addressable type OtherThing class is not an allowed class.
```

We can also use strings and symbols instead of the classes themselves:
```ruby
class Address < ActiveRecord::Base
    belongs_to :addressable, polymorphic: [:user, 'Company']
end
```
Provided that the strings and symbols translate to existing classes when used with `.classify.constantize`.

### Usage with namespaced models

```ruby
class Address < ActiveRecord::Base
    belongs_to :addressable, polymorphic: [Company::User, Company]
end
```

### Helper methods

Class methods:
- `Address.addressable_types`: returns the allowed classes
- `Address.with_addressable(#{type})`: generic finder method
- `Address.with_addressable_#{allowed_class_name}`: scope for each allowed class

Instance methods:
-  `Address.addressable_type_#{allowed_class_name}?`: check if it is from that specific class

### Helper methods with namespaced models

Class methods:
- `Address.with_addressable(Company::User)`
- `Address.with_addressable_company_user`
- `Address.addressable_type_company_user?`

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

Bug reports and pull requests are welcome on GitHub. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](./CODE_OF_CONDUCT.md).
