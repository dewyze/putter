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

There are two ways to use putter. `Putter.follow` and `Putter.watch`.

### Putter.follow

`Putter.follow` will allow you to create a wrapper around an object and then you can pass that wrapped object around. The advantage to using follow is that if a method is called that doesn't exist, or a method is created at runtime, the wrapped object will intercept those calls. This works on both instances and classes. However, following a class will not result in created instances of that class being followed.

Additionally, following an object will not allow you to intercept calls to a class that occurred outside the wrapped object. For that functionality, use `Putter.watch`

`Putter.follow` usage:

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
Putter Debugging: Object instance ./putter/README.md:57 -- Method: :hello, Args: [:world, "!"], Result: "Hello world!"
```

#### `Putter.follow` Options

```ruby
Putter.follow(
  object_to_follow,
  label: "My object",  # Label to use after "Putter Debugging:  My object". Will be "ClassName" for classes or "ClassName instance" for instances
  methods: ["value"],  # If the value is nil, then all methods will be watched. Otherwise, this is an array of methods to print debugging input for
)
```

### Putter.watch

`Putter.watch` can be used on classes to follow created instances of the class or to intercept method calls that occur throughout your application.

`Putter.follow` usage:

```ruby
class MyObject
  def self.hello_class(arg, punc)
    "The class says hello #{arg.to_s}#{punc}"
  end

  def hello_instance(arg, punc)
    "An instance says hello #{arg.to_s}#{punc}"
  end
end

Putter.watch(MyObject)
MyObject.hello_class("world", "!")
my_obj = MyObject.new
my_obj.hello_instance("world", "!")
```

Will output:

```bash
Putter Debugging: Object ./putter/README.md:96 -- Method: :hello_class, Args: [:world, "!"], Result: "The class says hello world!"
Putter Debugging: Object instance 1 ./putter/README.md:97 -- Method: :hello_instance, Args: [:world, "!"], Result: "The instance says hello world!"
```

#### `Putter.follow` Options

```ruby
Putter.watch(
  ClassToFollow,
  label: "My object",  # Label to use after "Putter Debugging:  My object". Will be "ClassName" for classes or "ClassName instance #" for instances
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

- Active Record specific printing
- Checking Rails.env to double check that putter is not called in production

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dewyze/putter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
