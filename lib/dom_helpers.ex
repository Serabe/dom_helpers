defmodule DomHelpers do
  @moduledoc """
  Just `use DomHelpers` to import all the methods.
  """

  defmacro __using__(_opts) do
    quote do
      import DomHelpers.Accessors
      import DomHelpers.Selectors
    end
  end
end
