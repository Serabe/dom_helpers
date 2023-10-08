defmodule DomHelpers.Assertions do
  @moduledoc """
  This module contains some extra helpers specially for assertions,
  though is preferred to use direct comparisons with the different
  [selectors](`DomHelpers.Selectors`) and [accessors](`DomHelpers.Accessors`).
  """

  import DomHelpers.Accessors

  @doc """
  Checks if the given selector is found at least once
  in the given document. Works like [`has_element?/2`](`Phoenix.LiveViewTest.has_element?/2`)
  but with the parameters reversed so you can pipe when
  building the selector.

  ## Example

  ```
  iex> "li" |> is_in?("<ul><li>First</li><li>Second</li></ul>")
  true

  iex> "li" |> is_in?("<ul><li>First</li></ul>")
  true

  iex> "span" |> is_in?("<ul><li>First</li></ul>")
  false
  ```
  """
  def is_in?(selector, htmlable) do
    find_count(htmlable, selector) > 0
  end
end
