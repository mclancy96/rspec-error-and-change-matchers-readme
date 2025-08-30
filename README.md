# RSpec: Error & Change Matchers

Welcome to Lesson 15! In this lesson, we're going to take a deep dive into some of RSpec's most powerful and flexible matchers: `raise_error`, `change`, `respond_to`, `satisfy`, and the ability to combine expectations with `and`/`or`. These matchers let you test for exceptions, state changes, custom logic, and even combine multiple expectations in a single line. We'll break down each matcher, show you how and when to use them, and provide lots of examples, output, and practice prompts. Let's get started!

---

## How These Matchers Fit In

Remember: All of these matchers are used with the `expect` method, just like the matchers you've seen in previous lessons. For example: `expect { ... }.to raise_error`, `expect(obj).to respond_to(:foo)`, etc. If you ever feel lost, look for the `expect`!

---

## Lesson Map

This lesson is organized into four main matcher categories:

1. **Error Matchers**: Checking for raised errors (`raise_error`)
2. **Change Matchers**: Checking for state changes (`change`)
3. **Method & Custom Logic Matchers**: Checking for method presence (`respond_to`) and custom logic (`satisfy`)
4. **Compound Expectations**: Combining matchers with `.and` and `.or`

---

## Why Error & Change Matchers Matter

Testing isn't just about checking if a value is what you expect. Sometimes, you want to make sure your code *raises* an error when it should, or that it *changes* something in your program's state. These matchers help you:

- Ensure your code fails safely and predictably (error matchers)
- Confirm that actions have the side effects you expect (change matchers)
- Test for custom logic or method presence (respond_to, satisfy)
- Write more expressive, readable, and robust specs

---

## 1. Error Matchers: `raise_error`

Sometimes, you want to make sure a block of code *raises* an error. This is especially important for testing validations, edge cases, or defensive programming. RSpec's `raise_error` matcher is your friend!

### Basic Usage

```ruby
# /spec/error_matchers_spec.rb
RSpec.describe "Error Matchers" do
  it "checks for raised errors" do
    expect { 1 / 0 }.to raise_error(ZeroDivisionError)
  end
end
```

**What happens?**

This spec passes, because dividing by zero in Ruby raises a `ZeroDivisionError`.

**Example Output (Passing):**

```zsh
Error Matchers
  checks for raised errors

Finished in 0.00123 seconds (files took 0.12345 seconds to load)
1 example, 0 failures
```

**Example Output (Failing):**

Suppose you expected a `ZeroDivisionError`, but no error was raised:

```zsh
Failure/Error: expect { 1 + 1 }.to raise_error(ZeroDivisionError)
  expected ZeroDivisionError, but nothing was raised
# ./spec/error_matchers_spec.rb:4
```

### Checking for Any Error

```ruby
# /spec/error_matchers_spec.rb
expect { raise "Oops!" }.to raise_error
```

This passes if *any* error is raised.

### Checking for Error Message

```ruby
# /spec/error_matchers_spec.rb
expect { raise "Oops!" }.to raise_error("Oops!")
```

### Checking for Error Class and Message

```ruby
# /spec/error_matchers_spec.rb
expect { raise ArgumentError, "Bad arg!" }.to raise_error(ArgumentError, "Bad arg!")
```

### Edge Cases

- If *no* error is raised, the spec fails (see above).
- If the *wrong* error is raised, the spec fails. For example:

```ruby
expect { 1 / 0 }.to raise_error(ArgumentError)
```

**Failing Output:**

```zsh
Failure/Error: expect { 1 / 0 }.to raise_error(ArgumentError)
  expected ArgumentError, got ZeroDivisionError
# ./spec/error_matchers_spec.rb:4
```

### Real-World Example: Validations

```ruby
# /spec/user_spec.rb
RSpec.describe User do
  it "raises when username is missing" do
    expect { User.create!(username: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
```

---

## 2. Change Matchers: `change`

Sometimes, you want to check that an action *changes* something—like the size of an array, the value of a variable, or a database record count. The `change` matcher is perfect for this!

### Usage

```ruby
# /spec/change_matchers_spec.rb
RSpec.describe "Change Matchers" do
  it "checks for state change" do
    arr = []
    expect { arr << 1 }.to change { arr.size }.by(1)
  end
end
```

**What happens?**

This spec passes, because `arr.size` goes from 0 to 1 (a change of +1).

**Example Output (Passing):**

```zsh
Change Matchers
  checks for state change

Finished in 0.00123 seconds (files took 0.12345 seconds to load)
1 example, 0 failures
```

**Example Output (Failing):**

Suppose the array doesn't change:

```ruby
arr = []
expect { arr }.to change { arr.size }.by(1)
```

```zsh
Failure/Error: expect { arr }.to change { arr.size }.by(1)
  expected `arr.size` to have changed by 1, but was changed by 0
# ./spec/change_matchers_spec.rb:4
```

### Checking for Specific Value Changes

```ruby
# /spec/change_matchers_spec.rb
expect { counter.increment }.to change { counter.value }.from(0).to(1)
```

### Checking for No Change

```ruby
# /spec/change_matchers_spec.rb
expect { do_nothing }.not_to change { obj.value }
```

### Multiple Changes

```ruby
# /spec/change_matchers_spec.rb
expect { arr.push(1, 2) }.to change { arr.size }.by(2)
```

### Real-World Example: Database Records

```ruby
# /spec/user_spec.rb
expect { User.create!(username: "bob") }.to change { User.count }.by(1)
```

---

---

## 3. Method & Custom Logic Matchers

### `respond_to`

Use `respond_to` to check if an object has a method. This is great for duck typing and making sure your objects have the right interface.

```ruby
# /spec/respond_to_satisfy_spec.rb
RSpec.describe "respond_to" do
  it "checks respond_to" do
    expect("hello").to respond_to(:upcase)
    expect([1,2,3]).to respond_to(:each)
    expect(42).not_to respond_to(:each)
  end
end
```

### `satisfy`

Use `satisfy` for custom logic that doesn't fit any other matcher. Pass a block that returns true or false.

```ruby
# /spec/respond_to_satisfy_spec.rb
RSpec.describe "satisfy" do
  it "checks satisfy" do
    expect(5).to satisfy { |n| n.odd? }
    expect("banana").to satisfy { |s| s.length > 3 }
  end
end
```

**Example Output (Passing):**

```zsh
satisfy
  checks satisfy

Finished in 0.00123 seconds (files took 0.12345 seconds to load)
1 example, 0 failures
```

**Failing Example:**

```ruby
expect(4).to satisfy { |n| n.odd? }
```

**Failing Output:**

```zsh
Failure/Error: expect(4).to satisfy { |n| n.odd? }
  expected 4 to satisfy block
# ./spec/respond_to_satisfy_spec.rb:4
```

**When to use `satisfy`?**

- When you need to check something unique or complex
- When no built-in matcher fits

---

---

## 4. Compound Expectations: `and` / `or`

Sometimes, you want to check *multiple* things about a value. RSpec lets you combine matchers with `and` and `or` for more expressive specs.

### Using `and`

```ruby
# /spec/compound_expectations_spec.rb
RSpec.describe "Compound Expectations" do
  it "combines matchers with and" do
    expect(10).to be > 5.and be < 20
    expect("RSpec").to start_with("R").and end_with("c")
  end
end
```

**Example Output (Passing):**

```zsh
Compound Expectations
  combines matchers with and

Finished in 0.00123 seconds (files took 0.12345 seconds to load)
1 example, 0 failures
```

**Failing Example:**

```ruby
expect(10).to be > 5.and be < 8
```

**Failing Output:**

```zsh
Failure/Error: expect(10).to be > 5.and be < 8
  expected > 5 and < 8
       got: 10
# ./spec/compound_expectations_spec.rb:4
```

### Using `or`

```ruby
# /spec/compound_expectations_spec.rb
RSpec.describe "Compound Expectations" do
  it "combines matchers with or" do
    expect("RSpec").to start_with("R").or end_with("z")
    expect([1,2,3]).to include(2).or include(99)
  end
end
```

**Example Output (Passing):**

```zsh
Compound Expectations
  combines matchers with or

Finished in 0.00123 seconds (files took 0.12345 seconds to load)
1 example, 0 failures
```

**Failing Example:**

```ruby
expect("RSpec").to start_with("X").or end_with("z")
```

**Failing Output:**

```zsh
Failure/Error: expect("RSpec").to start_with("X").or end_with("z")
  expected "RSpec" to start with "X" or end with "z"
# ./spec/compound_expectations_spec.rb:4
```

### Edge Cases & Gotchas

- Compound matchers only work with *one* expect per line.
- Chaining `.and`/`.or` is more reliable than using Ruby's `and`/`or` keywords.

---

---

## Practice Prompts

Try these exercises to reinforce your learning:

1. Write a spec that expects a `NoMethodError` when calling a missing method on a string.
2. Write a spec that expects a hash's size to change by 2 after adding two keys.
3. Write a spec that expects an array to *not* change after calling a method that returns a new array.
4. Write a spec that expects an object to respond to both `:to_s` and `:inspect`.
5. Write a spec using `satisfy` to check if a number is a perfect square.
6. Write a spec that combines `be > 0` and `be < 100` using `.and`.
7. Write a spec that expects a string to start with "A" or end with "Z" using `.or`.

---

## What's Next?

Great work! This is the last lesson of Unit 5. Up next is **Lab 5**, where you'll get hands-on practice writing specs using all the matchers covered in this unit. Be ready to apply what you've learned!

---

## Resources

- [RSpec: raise_error Matcher](https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/built-in-matchers/raise-error-matcher)
- [RSpec: change Matcher](https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/built-in-matchers/change-matcher)
- [RSpec: respond_to Matcher](https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/built-in-matchers/respond-to-matcher)
- [RSpec: satisfy Matcher](https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/built-in-matchers/satisfy-matcher)
- [RSpec: Compound Matchers](https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/composing-matchers)
- [Better Specs: Matchers](https://www.betterspecs.org/#expect)
