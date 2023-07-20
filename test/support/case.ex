defmodule DomHelpers.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      use DomHelpers
    end
  end
end
