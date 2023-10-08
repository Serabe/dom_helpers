defmodule DomHelpers do
  @moduledoc """
  Just `use DomHelpers` to import all the methods.

  For more information about accessor helpers, see `DomHelpers.Accessors`.

  For more information about selection helpers, see `DomHelpers.Selectors`.
  """

  defmacro __using__(_opts) do
    quote do
      import DomHelpers.Accessors
      import DomHelpers.Assertions
      import DomHelpers.Selectors
    end
  end
end
