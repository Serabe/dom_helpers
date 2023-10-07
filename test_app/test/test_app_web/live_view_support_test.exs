defmodule TestAppWeb.LiveViewSupportTest do
  use TestAppWeb.ConnCase
  use DomHelpers

  import LiveIsolatedComponent
  import Phoenix.Component, only: [sigil_H: 2]
  import Phoenix.LiveViewTest, only: [element: 2]

  test "supports views" do
    {:ok, view, _html} =
      live_isolated_component(fn assigns ->
        ~H"""
        <ul>
          <li>First</li>
          <li>Second</li>
        </ul>
        <ul>
          <li>Third</li>
        </ul>
        """
      end)

    assert view |> find("ul") |> find("li") |> Enum.map(&text/1) == ~w(First Second Third)
  end

  test "supports elements" do
    {:ok, view, _html} =
      live_isolated_component(fn assigns ->
        ~H"""
        <ul>
          <li>Only one</li>
        </ul>
        """
      end)

    assert view |> element("ul") |> text() == "Only one"
  end
end
