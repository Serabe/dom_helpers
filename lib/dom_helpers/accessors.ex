defmodule DomHelpers.Accessors do
  @moduledoc """
  Collection of methods to simplify the access to different parts of the DOM.
  """

  @doc """
  Retrieve the values of the given attribute in the given fragment.

  ## Examples

  ```
  iex> find(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "li") |> attribute("class")
  ~w(odd even odd)

  iex> find(~s(<ul><li class="odd" data-test="first">First</li><li class="even" data-test="second">Second</li><li class="odd" data-test="third">Third</li></ul>), "li") |> attribute("data-test")
  ~w(first second third)

  iex> find(~s(<ul><li class="odd" data-test="first">First</li><li class="even" data-test="second">Second</li><li class="odd" data-test="third">Third</li></ul>), ".even") |> attribute("data-test")
  ~w(second)
  ```
  """
  def attribute(htmlable, attr_name),
    do: htmlable |> parse!() |> Floki.attribute(attr_name)

  @doc """
  Behaves like `attribute/2` but uses the second argument as selector.

  ## Examples

  ```
  iex> attribute(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "li", "class")
  ~w(odd even odd)

  iex> attribute(~s(<ul><li class="odd" data-test="first">First</li><li class="even" data-test="second">Second</li><li class="odd" data-test="third">Third</li></ul>), "li", "data-test")
  ~w(first second third)

  iex> attribute(~s(<ul><li class="odd" data-test="first">First</li><li class="even" data-test="second">Second</li><li class="odd" data-test="third">Third</li></ul>), ".even", "data-test")
  ~w(second)
  ```
  """
  def attribute(htmlable, selector, attr_name),
    do: htmlable |> parse!() |> Floki.attribute(selector, attr_name)

  @doc """
  Convenience method for piping when building a selector. Behaves like `attribute/3` but
  first argument is the selector and the second one is the htmlable.

  ## Examples

  ```
  iex> attribute_in("li", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "class")
  ~w(odd even odd)

  iex> attribute_in("li", ~s(<ul><li class="odd" data-test="first">First</li><li class="even" data-test="second">Second</li><li class="odd" data-test="third">Third</li></ul>), "data-test")
  ~w(first second third)

  iex> attribute_in(".even", ~s(<ul><li class="odd" data-test="first">First</li><li class="even" data-test="second">Second</li><li class="odd" data-test="third">Third</li></ul>), "data-test")
  ~w(second)
  ```
  """
  def attribute_in(selector, htmlable, attr_name),
    do: attribute(htmlable, selector, attr_name)

  @doc """
  Return a list of the classes of the current fragment.

  ## Examples

  ```
  iex> classes(~s(<div class="some classes here">Hello</div>))
  [~w(some classes here)]

  iex> classes(~s(<div class=" some   classes  here ">Hello</div>))
  [~w(some classes here)]

  iex> classes(~s(<li class="odd first">1</li><li class="even second">2</li>))
  [~w(odd first), ~w(even second)]
  ```
  """
  def classes(htmlable),
    do: htmlable |> attribute("class") |> Enum.map(&String.split(&1, " ", trim: true))

  @doc """
  Return a list with the list of classes of all the elements that satisfy the selector
  in the given fragment.

  ## Example

  ```
  iex> classes(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".odd")
  [["odd"], ["odd"]]

  iex> classes(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "li")
  [["odd"], ["even"], ["odd"]]

  iex> classes(~s[<div class="one two three">Content</div><div class="four five">Other</div>], "div")
  [["one", "two", "three"], ["four", "five"]]
  ```
  """
  def classes(htmlable, selector),
    do: htmlable |> find(selector) |> Enum.flat_map(&classes/1)

  @doc """
  Convenience method for piping when building a selector. Behaves like `classes/2` but
  first argument is the selector.

  ## Example

  ```
  iex> classes_in(".odd", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  [["odd"], ["odd"]]

  iex> classes_in("li", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  [["odd"], ["even"], ["odd"]]

  iex> classes_in("div", ~s[<div class="one two three">Content</div><div class="four five">Other</div>])
  [["one", "two", "three"], ["four", "five"]]
  ```
  """
  def classes_in(selector, htmlable), do: classes(htmlable, selector)

  @doc """
  Finds all the nodes in the htmlable that satisfy the selector.

  ## Examples

  ```
  iex> find(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".odd")
  [{"li", [{"class", "odd"}], ["First"]}, {"li", [{"class", "odd"}], ["Third"]}]

  iex> find(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".even")
  [{"li", [{"class", "even"}], ["Second"]}]

  iex> find(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".none")
  []

  iex> find(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "li")
  [{"li", [{"class", "odd"}], ["First"]}, {"li", [{"class", "even"}], ["Second"]}, {"li", [{"class", "odd"}], ["Third"]}]
  ```
  """
  def find(htmlable, selector), do: htmlable |> parse!() |> Floki.find(selector)

  @doc """
  Convenience method for piping when building a selector. Behaves like `find/2` but
  first argument is the selector.

  ## Examples

  ```
  iex> find_in(".odd", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  [{"li", [{"class", "odd"}], ["First"]}, {"li", [{"class", "odd"}], ["Third"]}]

  iex> find_in(".even", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  [{"li", [{"class", "even"}], ["Second"]}]

  iex> find(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".none")
  []

  iex> find_in("li", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  [{"li", [{"class", "odd"}], ["First"]}, {"li", [{"class", "even"}], ["Second"]}, {"li", [{"class", "odd"}], ["Third"]}]
  ```
  """
  def find_in(selector, htmlable), do: find(htmlable, selector)

  @doc """
  Returns the number of elements that satisfy the given selector.

  ## Examples

  ```
  iex> find_count(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".odd")
  2

  iex> find_count(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".even")
  1

  iex> find_count(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".none")
  0

  iex> find_count(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "li")
  3
  ```
  """
  def find_count(htmlable, selector), do: htmlable |> find(selector) |> length()

  @doc """
  Convenience method for piping when building a selector. Behaves like `find_count/2` but
  first argument is the selector.

  ## Examples

  ```
  iex> find_count_in(".odd", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  2

  iex> find_count_in(".even", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  1

  iex> find_count_in(".none", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  0

  iex> find_count_in("li", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  3
  ```
  """
  def find_count_in(selector, htmlable), do: find_count(htmlable, selector)

  @doc """
  Like `find/2` but gets the first instance.

  ## Examples

  ```
  iex> find_first(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".odd")
  {"li", [{"class", "odd"}], ["First"]}

  iex> find_first(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".even")
  {"li", [{"class", "even"}], ["Second"]}

  iex> find_first(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".none")
  nil

  iex> find_first(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "li")
  {"li", [{"class", "odd"}], ["First"]}
  ```
  """
  def find_first(htmlable, selector), do: htmlable |> find(selector) |> List.first()

  @doc """
  Convenience method for piping when building a selector. Behaves like `find_first/2` but
  first argument is the selector.

  ## Examples

  ```
  iex> find_first_in(".odd", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  {"li", [{"class", "odd"}], ["First"]}

  iex> find_first_in(".even", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  {"li", [{"class", "even"}], ["Second"]}

  iex> find_first_in(".none", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  nil

  iex> find_first_in("li", ~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>))
  {"li", [{"class", "odd"}], ["First"]}
  ```
  """
  def find_first_in(selector, htmlable), do: find_first(htmlable, selector)

  @doc """
  Returns the whole text inside the html fragment passed in. Spaces are normalised (meaning that if there are multiple
  spaces together they are reduced to just one and the text is trimmed on both ends).

  First arguments is an htmlable (see `DomHelpers.Htmlable`), second can either be a selector or options. If a selector
  is passed in, `find/2` will be used to locate matching elements before getting the text. In case a selector is given,
  a third optional argument with options can be passed in.

  Options to `Floki.text/2` can be passed inside the `:text` key in the options.

  ## Examples

  ```
  iex> text(~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>), ".odd")
  "First Third"

  iex> text(~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>), ".even")
  "Second"

  iex> text(~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>), ".none")
  ""

  iex> text(~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>), "li")
  "First Second Third"

  iex> find(~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>), "li") |> Enum.map(&text/1)
  ~w(First Second Third)
  ```
  """
  def text(htmlable, selector_or_options \\ [], options \\ [])

  def text(htmlable, selector, opts) when is_binary(selector),
    do: htmlable |> find(selector) |> text(opts)

  def text(htmlable, options, _nothing),
    do:
      htmlable
      |> parse!()
      |> Floki.text(Keyword.get(options, :text, []))
      |> String.replace(~r/\s+/, " ")
      |> String.trim()

  @doc """
  Convenience method for piping when building a selector. Behaves like `text/3` but
  first argument is the selector. Selector is not optional in this function.

  ## Examples

  ```
  iex> text_in(".odd", ~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>))
  "First Third"

  iex> text_in(".even", ~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>))
  "Second"

  iex> text_in(".none", ~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>))
  ""

  iex> text_in("li", ~s(<ul><li class="odd"> First </li> <li class="even"> Second </li> <li class="odd"> Third </li></ul>))
  "First Second Third"
  ```
  """
  def text_in(selector, htmlable, options \\ []),
    do: text(htmlable, selector, options)

  # If it is already parsed.
  defp parse!(tree) when is_list(tree) or is_tuple(tree), do: tree

  defp parse!(htmlable),
    do: htmlable |> DomHelpers.Htmlable.to_html() |> Floki.parse_fragment!()
end
