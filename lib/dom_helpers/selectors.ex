defmodule DomHelpers.Selectors do
  @moduledoc """
  Collection of methods to simplify the creation of complex selectors.
  """

  @doc """
  Complements the selector by checking that the attribute is present.
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
  """
  def with_attr(selector, attr, value),
    do: "#{selector}[\"#{attr}\"#{matcher(value)}\"#{get_attr_value(value)}\"]"

  @doc """
  Complements the selector by checking that it does not have the given attribute.
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
