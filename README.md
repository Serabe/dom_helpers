# DomHelpers

[![Module Version](https://img.shields.io/hexpm/v/dom_helpers.svg)](https://hex.pm/packages/dom_helpers)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/dom_helpers/)
[![License](https://img.shields.io/hexpm/l/dom_helpers.svg)](https://github.com/Serabe/dom_helpers/blob/main/LICENSE.txt)

`DomHelpers` is a collection of helpers for creating selectors and ways of accessing different parts of the dom.
`DomHelpers` also accept as documents anything like `Phoenix.LiveViewTest.View`s, `Phoenix.LiveViewTest.Element`s or
`Plug.Conn`s.

`DomHelpers` is built on top of [`Floki`](https://github.com/philss/floki) to provide some sweet helpers for your tests.

## Installation

Add the following package to `mix.exs`:

```elixir
def deps do
  [
    {:dom_helpers, "~> 0.2.0", only: [:dev, :test]}
  ]
end
```

## Why?

### DomHelpers.Accessors

ExUnit does not have an API for implementing assertions with support for custom messages. That makes that when an assertion
like `has_element?/2` or `has_element?/3` fails, we get a huge error printing out either the view struct or the html passed
in. Furthermore, the API for testing dead controllers and dead views are different. `find/2` can be used with views and elements
in LiveView testing, with controllers when in a classic Phoenix app, and with any kind of html anywhere.

Furthermore, `dom_helpers` encourage better testing practices (`=~` I'm looking at you) by providing easy ways to access
different part of the DOM. For example, `text/3` provides several pros over `has_element?/3` or `render(view) =~`:

1. Easier debugging when a test fails. True story, the first problem I had while maintaining an app was that a formatted date
   was not matching the expected output. In that same page there were over 8 different dates, and the matcher was
   `render(view) =~ formatted_date`, so most of the time was figuring out which of the dates was supposed to match. While it might
   be obvious for someone used to the codebase, new developers will struggle with this.
2. Better error when failing. When `has_element?/3` fails, you get a dump of the whole struct or html and the other arguments.
   When `text/3 == some_text` fails, you get a nice diff with the differences.
3. Tests are easier to reason about. I've seen and experiences problems with tests that were testing things like dates, percentages,
   numbers, etc. In these cases, having some assertion like `assert has_element?(view, date_selector, "2nd Feb")` can easily give false
   positives, as `"22nd Feb"` will match without problem.

### DomHelpers.Selectors

Selectors can get really complicated and hard to parse when reading. For example, reading:

```elixir
with_attrs("input", %{
  checked: true,
  type: "checkbox",
  value: "t",
  class: {:contains_word, "primary"},
  name: {:ends_with, "[remember_me]"}
})
```

is much easier than reading:

```elixir
~s/input["name"$="[remember_me]"]["type"="checkbox"]["value"="t"]["checked"]["class"~="primary"]
```

or even:

```elixir
~s/input[name$="[remember_me]"][type=checkbox][value=t][checked][class~=primary]
```

It is more verbose, but the intent is clearer.

They are also chainable: you can easily create more complex selectors for your app based on these.

```elixir
input_being_tested = "input" |> with_attrs(type: "checkbox", name: {:ends_with, "[remember_me]"}) |> without_class("secondary")

assert has_element?(view, with_attr(input_being_tested, :checked))

# Some actions

assert has_element?(view, without_attr(input_being_tested, :checked))
```

## Usage

Just add `use DomHelpers` in your tests. It will import all helpers from the different modules.
If you are interested in more granular control, just manually `alias` or `import` each module.

### Selectors

There are several helpers for constructing complex selectors in [`DomHelpers.Selectors`](https://hexdocs.pm/dom_helpers/DomHelpers.Selectors.html).
There are many interesting helpers, but please, take special attention to:

- [`with_attr/3`](https://hexdocs.pm/dom_helpers/DomHelpers.Selectors.html#with_attr/3) and how you can provide values to use different matchers.
- [`with_attrs/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Selectors.html#with_attrs/2) that lets you provide complex attribute selectors easily and in a readable way. It also handles some current caveats in Floki.

You can find some other helpers for dealing with classes and ids too.

Please, request extra helpers if you find anything you need.

### Accessors

Currently, the following accessors are available in [`DomHelpers.Accessors`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html):

- [`attribute/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#attribute/2) and [`attribute/3`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#attribute/3) lets you access attributes values by the attribute name.
- [`classes/1`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#classes/2) and [`classes/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#classes/2) let you access the `class` attribute as a list of classes. If you want the full, unparsed string, use `attribute/2` or `attribute/3` instead.
- [`find/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#find/2) let's you find all the elements that satisfy a given selector.
- [`find_count/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#find_count/2) is pretty much syntactic sugar for `find(html, selector) |> length()`
- [`find_first/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#find_first/2) is pretty much syntactic sugar for `find(html, selector) |> List.first()`. Frontend developers beware that while in JS we have `querySelector` and `querySelectorAll`, in `dom_helpers` by default all matching elements are returned.
- [`text/3`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#text/3) returns the text. Please, read the documentation for all the possibilities.

For more details on usage and some sweet examples, please refer to the linked documentation.

Please, request extra helpers if you find anything you need.