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
