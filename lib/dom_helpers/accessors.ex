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
  Return a list of the classes of the current fragment.

  ## Examples

  ```
  iex> classes(~s(<div class="some classes here">Hello</div>))
  ~w(some classes here)

  iex> classes(~s(<div class=" some   classes  here ">Hello</div>))
  ~w(some classes here)
  ```
  """
  def classes(htmlable),
    do: htmlable |> attribute("class") |> List.first("") |> String.split(" ", trim: true)

  @doc """
  Return a list with the list of classes of all the elements that satisfy the selector
  in the given fragment.

  ## Example

  ```
  iex> classes(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), ".odd")
  [["odd"], ["odd"]]

  iex> classes(~s(<ul><li class="odd">First</li><li class="even">Second</li><li class="odd">Third</li></ul>), "li")
  [["odd"], ["even"], ["odd"]]
  ```
  """
  def classes(htmlable, selector),
    do: htmlable |> find(selector) |> Enum.map(&classes/1)

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

  # If it is already parsed.
  defp parse!(tree) when is_list(tree) or is_tuple(tree), do: tree

  defp parse!(htmlable),
    do: htmlable |> DomHelpers.Htmlable.to_html() |> Floki.parse_fragment!()
end
