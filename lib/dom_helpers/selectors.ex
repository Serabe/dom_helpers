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
  """
  def with_attr(selector, attr, value), do: "#{selector}[\"#{attr}\"=\"#{value}\"]"
end
