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
- [`find/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#find/2) let's you find all the elements that satisfy a given selector.
- [`find_count/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#find_count/2) is pretty much syntactic sugar for `find(html, selector) |> length()`
- [`find_first/2`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#find_first/2) is pretty much syntactic sugar for `find(html, selector) |> List.first()`. Frontend developers beware that while in JS we have `querySelector` and `querySelectorAll`, in `dom_helpers` by default all matching elements are returned.
- [`text/3`](https://hexdocs.pm/dom_helpers/DomHelpers.Accessors.html#text/3) returns the text. Please, read the documentation for all the possibilities.

For more details on usage and some sweet examples, please refer to the linked documentation.

Please, request extra helpers if you find anything you need.