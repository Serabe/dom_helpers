defmodule TestAppWeb.PlugConnSupportTest do
  use TestAppWeb.ConnCase

  use DomHelpers

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    assert conn |> find(".list li") |> Enum.map(&text/1) == ~w(First Second Third)
  end
end
