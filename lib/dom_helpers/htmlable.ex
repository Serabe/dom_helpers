defprotocol DomHelpers.Htmlable do
  @moduledoc """
  Implements conversion from anything to something Floki can parse.
  """
  @fallback_to_any true

  @doc """
  Convert the given input to a parseable HTML fragment.
  """
  def to_html(htmlable)
end

defimpl DomHelpers.Htmlable, for: Any do
  def to_html(term), do: String.Chars.to_string(term)
end

defimpl DomHelpers.Htmlable, for: Phoenix.LiveViewTest.View do
  def to_html(view), do: Phoenix.LiveViewTest.render(view)
end

defimpl DomHelpers.Htmlable, for: Phoenix.LiveViewTest.Element do
  def to_html(element), do: Phoenix.LiveViewTest.render(element)
end

defimpl DomHelpers.Htmlable, for: Plug.Conn do
  def to_html(conn), do: Phoenix.ConnTest.html_response(conn, 200)
end
