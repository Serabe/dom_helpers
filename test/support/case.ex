defmodule DomHelpers.Case do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      use DomHelpers
    end
  end
end
