# Testing Ruby Applications with RSPec

## The RSpec family
RSpec is composed of three libraries:
- `rspec-core`: Runner and syntax
- `rspec-expectations`: Express desired outcomes
- `rspec-mocks`: Test doubles

Installing the rspec gem means installing all these three dependencies.

RSpec documentation can be found at https://relishapp.com/rspec/ or API-level docs at http://rspec.info/documentation/3.9/rspec-core/

The RSpec motivation relies on two goals:
1. Automatically verify correctness
2. Document desired behavior

## it and describe
The `it` block is used to specify a property, that's what is called an "Example".

The `describe` block is used to group examples, that is, to group `it` blocks.

## Testing practices
1. Behavior over implementation. Tests should depend on the desired behavior, not on the way that behavior is implemented.
2. Confidence over proof. Specs should not attempt to be a complete proof of correctness.

## RSpec CLI
The CLI piece of RSpec has some features hidden:
- `rspec --format doc` gives a more verbose description of the examples and the results
- `rspec --format html > results.html` saves the results in a html file.
- Running `rspec` by itself runs the specs found in the `spec/` folder. Inside this folder, all the dependencies added with `require` are implicitly included in the `lib/` folder.
- All the flags that want to be run with the `rspec` command can be saved in a `.rspec` file. Also there is a `.rspec-local` file that overwrites `.rspec` and should be git ignored.

## Usual Project's Organization
A ruby project usually contains the following directories:
- /bin contains all the binaries for the project. That is, all the commands that can be executed from the command line.
- /lib contains all the modules and the actual code.
- /spec contains the tests. The same directory structure used inside the lib/ folder is usually replicated here on the /spec folder, but with the corresponding specs for each module.


## Acceptance tests
How can we test the entire thing as a whole? This is a different approach to unit tests, which pretend to test specific behavior of objects or modules. In acceptance tests we want to test everything from the user side of view

- Acceptance tests are general, unit tests are specific
- When an acceptance test fails the problem is unclear, when a unit test fails it is commonly easy to identify the issue.
- Acceptance tests are slower than unit tests, usually in a factor on 10x.

Generally there are 3 types of tests:
1. Unit tests, which check if objects do the right thing, and if they are convenient to work with.
2. Integration tests, which check if our code work agains objects we cann't change.
3. Acceptance tests, which check if the whole system works.

It usually good practice to have more unit tests than integration tests, and more integrations tests than acceptance tests.

## Hooks

RSpec provides a `before` method that receives a block, which is executed before every something is executed. So:
```ruby
before :example do
  # will run once per example in the defined context and sub contexts
end
```
```ruby
before :context do
  # will run once per context
end
```

```ruby
before :suite do
  # will run once per spec run
end
```

There are also hooks for `after` and `around`.
Hooks can also defined in config files like the spec_helper, using `config.before` or its similar pairs for after and around. There is a small caveat though, and it's that using many hooks defined outside of files or in huge contexts can become overwhelming when reading and trying to understand the spec code.

## Custom matchers
Additional to the built-in matchers that RSpec expectations come with, custom matchers can be built manually.

```ruby
module ArrayMatchers
  extend RSpec::Matchers::DSL

  matcher(:matcher_name) do |arguments|
    match do |arguments|
      # ...
    end

    failure_message do |arguments|
      # ...
    end
  end
end
```

Then, this module can be included in any RSpec context and use the matcher in a `expect(...).to` or `expect(...).not_to` statement.
