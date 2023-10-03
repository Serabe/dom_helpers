defprotocol DomHelpers.Htmlable do
  @fallback_to_any true

  @doc """
  Convert the given input to a parseable HTML fragment.
  """
  def to_html(htmlable)
end

defimpl DomHelpers.Htmlable, for: Any do
  def to_html(term), do: String.Chars.to_string(term)
end

defmodule DomHelpers.Utils do
  def module_compiled?(module) do
    function_exported?(module, :__info__, 1)
  end
end

if DomHelpers.Utils.module_compiled?(Phoenix.LiveViewTest.View) do
  defimpl DomHelpers.Htmlable, for: Phoenix.LiveViewTest.View do
    def to_html(view), do: Phoenix.LiveViewTest.render(view)
  end
end

if DomHelpers.Utils.module_compiled?(Phoenix.LiveViewTest.Element) do
  defimpl DomHelpers.Htmlable, for: Phoenix.LiveViewTest.Element do
    def to_html(element), do: Phoenix.LiveViewTest.render(element)
  end
end

if Enum.all?([Plug.Conn, Phoenix.ConnTest], &DomHelpers.Utils.module_compiled?/1) do
  defimpl DomHelpers.Htmlable, for: Plug.Conn do
    def to_html(conn), do: Phoenix.ConnTest.html_response(conn, 200)
  end
end
