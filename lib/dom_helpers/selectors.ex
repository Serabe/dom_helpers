defmodule DomHelpers.Selectors do
  @moduledoc """
  Collection of methods to simplify the creation of complex selectors.
  """

  @doc """
  Complements the selector by checking that the attribute is present.

  ## Examples

  ```
  iex> with_attr("input", "checked")
  ~s/input["checked"]/
  ```
  """
  def with_attr(selector, attr), do: "#{selector}[\"#{attr}\"]"

  @doc """
  Complements the selector by checking that the attribute has the given value.

  Value can either be a value or a tuple `{matcher_name, value}` where `matcher_name`
  can be one of:

  - `:contains_word` for `~=`.
  - `:contains` for `*=`.
  - `:equal` for `=`.
  - `:ends_with` for `$=`.
  - `:starts_with` for `^=`.
  - `:subcode` for `|=`.

  For more information on these selectors, please check [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors).

  ## Examples

  ```
  iex> with_attr("input", "type", "text")
  ~s/input["type"="text"]/

  iex> with_attr("input", "class", {:contains_word, "hidden"})
  ~s/input["class"~="hidden"]/

  iex> with_attr("input", "type", {:equal, "text"})
  ~s/input["type"="text"]/

  iex> with_attr("div", "data-test", {:ends_with, "editor"})
  ~s/div["data-test"$="editor"]/

  iex> with_attr("div", "data-test", {:starts_with, "editor"})
  ~s/div["data-test"^="editor"]/

  iex> with_attr("main", "lang", {:subcode, "es"})
  ~s/main["lang"|="es"]/
  ```
  """
  def with_attr(selector, attr, value),
    do: "#{selector}[\"#{attr}\"#{matcher(value)}\"#{get_attr_value(value)}\"]"

  @doc """
  Complements the selector by checking that it does not have the given attribute.

  ## Examples

  ```
  iex> without_attr("input", "checked")
  ~s/input:not(["checked"])/
  ```
  """
  def without_attr(selector, attr), do: "#{selector}:not(#{with_attr("", attr)})"

  @doc """
  Like `with_attr/2` but several attributes can be passed at once.

  Attributes can be passed as a map or keywords. In both cases, keys are the names
  of the attributes, while the keys can be:

  - `true` for just checking that the attribute is present.
  - `false` for checking that the attribute is not present.
  - Any other value would be passed directly as attribute value to `with_attr/3`. Check
    its documentation for all the options.

  ## Examples

  ```
  iex> with_attrs("input", type: "checkbox", checked: true)
  ~s/input["type"="checkbox"]["checked"]/

  iex> with_attrs("input", name: false, class: {:contains_word, "hola"}, "data-test": false)
  ~s/input["class"~="hola"]:not(["name"]):not(["data-test"])/
  ```
  """
  def with_attrs(selector, attrs) when is_map(attrs) or is_list(attrs) do
    {without_attr, with_attr} =
      Enum.split_with(attrs, fn
        {_attr, false} -> true
        _other -> false
      end)

    selector_with_valid_attrs =
      Enum.reduce(with_attr, selector, fn
        {attr, true}, selector ->
          with_attr(selector, attr)

        {attr, value}, selector ->
          with_attr(selector, attr, value)
      end)

    Enum.reduce(without_attr, selector_with_valid_attrs, fn {attr, false}, selector ->
      without_attr(selector, attr)
    end)
  end

  @doc """
  Add the class selector to the given one.

  ## Examples

  ```
  iex> with_class("div", "hidden")
  "div.hidden"

  iex> with_class("span", "flex")
  "span.flex"
  ```
  """
  def with_class(selector, class), do: "#{selector}.#{class}"

  @doc """
  Checks if the selector contains the given classes.

  ## Examples

  ```
  iex> with_classes("div", ~w(flex mb-4))
  "div.flex.mb-4"

  iex> with_classes("span", ~w(p-1 m-2))
  "span.p-1.m-2"
  ```
  """
  def with_classes(selector, classes) when is_list(classes) do
    Enum.reduce(classes, selector, &with_class(&2, &1))
  end

  @doc """
  Modifies the selector to check it does not have the given class.

  ## Examples

  ```
  iex> without_class("div", "hidden")
  ~s/div:not(.hidden)/
  ```
  """
  def without_class(selector, class), do: "#{selector}:not(.#{class})"

  @doc """
  Modifies the selector to check it does not contain the given classes.

  ## Examples

  ```
  iex> without_classes("div", ~w(flex mb-4))
  ~s/div:not(.flex):not(.mb-4)/
  ```
  """
  def without_classes(selector, classes) when is_list(classes) do
    Enum.reduce(classes, selector, &without_class(&2, &1))
  end

  @doc """
  Adds the given id to the selector passed in.

  ## Examples

  ```
  iex> with_id("main", "main_content")
  "main#main_content"

  iex> with_id("div", "modal")
  "div#modal"
  ```
  """
  def with_id(selector, id), do: "#{selector}##{id}"

  defp get_attr_value({_matcher, value}), do: value
  defp get_attr_value(value), do: value

  defp matcher({:contains_word, _value}), do: "~="
  defp matcher({:contains, _value}), do: "*="
  defp matcher({:equal, _value}), do: "="
  defp matcher({:ends_with, _value}), do: "$="
  defp matcher({:starts_with, _value}), do: "^="
  defp matcher({:subcode, _value}), do: "|="
  defp matcher(_value), do: "="
end
