# Putter

It rhymes with gooder, not gutter.

Putter is a tool for more easily implementing puts debugging. Instead of littering files with various puts statements, you can wrap an object with a follower and print out anytime a method is called on that object. This will follow the object throughout its path in the stack.

For now Putter can only follow a specific the speficic object that it wraps. It currently does not watch a class to see what objects were passed to it unless that specific instance of the class is passed through the stack.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'putter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install putter

## Usage

### Putter.follow

Currently there is only one use for Putter, the `follow` method.

```ruby
class MyObject
  def hello(arg, punc)
    "Hello #{arg.to_s}#{punc}"
  end
end

module Service
  def self.do_stuff(obj)
    obj.hello(:world, "!")
  end
end

object = Putter.follow(MyObject.new)
Service.do_stuff(object)
```

Will output:

```bash
Putter Debugging: Object instance /home/johndoe/putter/README.md:51 -- Method: :hello, Args: [:world, "!"], Result: "Hello world!"
```

#### `Putter.follow` Options

```ruby
Putter.follow(
  object_to_follow,
  label: "My object",  # Label to use after "Putter Debugging:  My object". Will be "ClassName" for classes or "ClassName instance" for instances
  methods: ["value"],  # If the value is nil, then all methods will be watched. Otherwise, this is an array of methods to print debugging input for
)
```

## Configuration

Putter currently has 3 configuration options:

```ruby
Putter.configure do |config|
  # 'print_strategy' takes a block that receives five arguments with the label, line,
  # method, args array, and result respectively. This block will be used after each method
  # is called, it must contain puts or logger calls, to print or any other method callbacks
  # that are helpful.
  # Defaults to Putter::PrintStrategy::Default
  config.print_strategy = Proc.new do |label, line, method, args, result|
    puts "#{line} - Label: #{label}, Method: #{method}, Args: #{args}, Result: #{result}"
  end

  # 'ignore_methods_from' takes an array of class names and will ignore both class and instance methods
  # from those classes when adding methods to the proxy and adding debug output
  # Defaults to [Object]
  config.ignore_methods_from = [Object, ActiveRecord::Base]

  # 'methods_whitelist' takes an array of methods and will always proxy and debug those methods
  # regardless of whether or not the class is ignored and regardless of what methods are passed
  # in when running 'Putter.follow'
  config.methods_whitelist = [:to_s]
end
```

## Planned Features
Feel free to open a PR to implement any of these if they are not yet added:

- Ability to watch any instance of a class calling a method
- Active Record specific printing
- Checking Rails.env to double check that putter is not called in production

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dewyze/putter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
