<p align="center">
  <a href="https://github.com/mirego/louche">
    <img src="http://i.imgur.com/qCu7dpr.png" alt="Louche" />
  </a>
  <br />
  Louche adds common validators for ActiveModel/ActiveRecord classes.
  <br /><br />
  <a href="https://rubygems.org/gems/louche"><img src="https://badge.fury.io/rb/louche.png" /></a>
  <a href="https://travis-ci.org/mirego/louche"><img src="https://travis-ci.org/mirego/louche.png?branch=master" /></a>
</p>

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'louche'
```

## Usage

Louche provides a few validators to use in your ActiveModel/ActiveRecord classes. You can use all validators with a lowercase
symbolized version of their prefix as the key and `true` as the value. For example, for `EmailValidator`:

```ruby
class User < ActiveRecord::Base
  validates :email, email: true
end
```

Optionally, if you wish to customize the default options, you can pass a hash as the value:

```ruby
class User < ActiveRecord::Base
  validates :email, email: { regex: /^.*@.*$/, message: :blank }
end
```

Here are the validators that Louche provides along with their respective options:

### `EmailValidator`

#### Example

```ruby
class User < ActiveRecord::Base
  validates :email, email: true
end

User.new(email: 'foo@example.com').valid? # => true
User.new(email: 'foo@example').valid? # => false
```

#### Options

| Option     | Description
|------------|-----------------------------------------------------
| `:regex`   | The regex used to validate the email (default: `/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i`)
| `:message` | The ActiveRecord message added to the record errors (default: `:invalid_email`)

### `URLValidator`

#### Example

```ruby
class User < ActiveRecord::Base
  validates :website, url: true
end

User.new(website: 'http://example.com').valid? # => true
User.new(website: 'example.$$$').valid? # => false
```

#### Options

| Option     | Description
|------------|-----------------------------------------------------
| `:schemes` | The URI schemes to allow (default: `%w(http https)`)
| `:message` | The ActiveRecord message added to the record errors (default: `:invalid_url`)

### `PhoneNumberValidator`

#### Example

```ruby
class User < ActiveRecord::Base
  validates :phone_number, phone_number: true
end

user = User.new(phone_number: '514 555-2525')
user.valid? # => true
user.phone_number # => '5145552525'

user = User.new(phone_number: '555-2525')
user.valid? # => false
user.phone_number # '5552525'
```

#### Options

| Option           | Description
|------------------|-----------------------------------------------------
| `:regex`         | The regex used to validate the number (default: `/\A\d{10,}\z/`)
| `:cleanup_regex` | The regex used to validate clean the input before validating/saving it (default: `/[^\d]/`)
| `:message`       | The ActiveRecord message added to the record errors (default: `:invalid_phone_number`)

### `PostalCodeValidator`

#### Example

```ruby
class User < ActiveRecord::Base
  validates :postal_code, postal_code: true
end

user = User.new(postal_code: 'G0R 2T0')
user.valid? # => true
user.postal_code # => 'G0R2T0'

user = User.new(postal_code: 'L -0- L')
user.valid? # => false
user.postal_code # => 'L0L'
```

#### Options

| Option           | Description
|------------------|-----------------------------------------------------
| `:regex`         | The regex used to validate the code (default: `/\A[a-z]\d[a-z]\d[a-z]\d\z/i`)
| `:cleanup_regex` | The regex used to validate clean the input before validating/saving it (default: `/[^a-z0-9]/i`)
| `:message`       | The ActiveRecord message added to the record errors (default: `:invalid_postal_code`)

### `ArrayValidator`

#### Example

```ruby
class Tag < Struct.new(:name)
  def valid?
    name.present?
  end
end

class User < ActiveRecord::Base
  validates :tags, array: true

  def tags=(tags)
    super tags.map { |tag| Tag.new(tag) }
  end
end

User.new(tags: ['food', 'beer', 'code']).valid? # => true
User.new(tags: ['food', '', 'code']).valid? # => false
```

#### Options

| Option             | Description
|--------------------|-----------------------------------------------------
| `:message`         | The ActiveRecord message added to the record errors (default: `:invalid_array`)
| `:validity_method` | The method that will be sent to each array item (default: `:valid?`)

## Localized error messages

Louche uses standard ActiveRecord messages. Here’s what your
`config/locales/activerecord.en.yml` file could look like:

```yaml
en:
  errors:
    messages:
      invalid_email: is not a valid email address
      invalid_url: is not a valid URL
      invalid_phone_number: is not a valid phone number
      invalid_postal_code: is not a valid postal code
      invalid_array: contains invalid items
```

## License

`Louche` is © 2014 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/louche/blob/master/LICENSE.md) file.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
