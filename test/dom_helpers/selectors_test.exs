defmodule DomHelpers.SelectorsTest do
  @moduledoc false
  use DomHelpers.Case

  doctest DomHelpers.Selectors

  import DomHelpers.Selectors

  describe "with_attr" do
    test "with just an attribute name, check that it has it" do
      assert ~s(input["checked"]) == with_attr("input", "checked")
      assert ~s(div["data-test-hello"]) == with_attr("div", "data-test-hello")
    end

    test "with attribute name and a plain value, check for equality" do
      assert ~s(input["type"="text"]) == with_attr("input", "type", "text")
      assert ~s(div["data-test"="something"]) == with_attr("div", "data-test", "something")
    end

    test "with attribute and {:equal, value}, check for equality" do
      assert ~s(input["type"="text"]) == with_attr("input", "type", {:equal, "text"})

      assert ~s(div["data-test"="something"]) ==
               with_attr("div", "data-test", {:equal, "something"})
    end

    test "with attribute and {:contains_word, value}, check for word in list" do
      assert ~s(input["type"~="text"]) == with_attr("input", "type", {:contains_word, "text"})

      assert ~s(div["data-test"~="something"]) ==
               with_attr("div", "data-test", {:contains_word, "something"})
    end

    test "with attribute and {:subcode, value}, check for exact match or followed by -" do
      assert ~s(input["type"|="text"]) == with_attr("input", "type", {:subcode, "text"})

      assert ~s(div["data-test"|="something"]) ==
               with_attr("div", "data-test", {:subcode, "something"})
    end

    test "with attribute and {:starts_with, value}, check for attr starting with value" do
      assert ~s(input["type"^="text"]) == with_attr("input", "type", {:starts_with, "text"})

      assert ~s(div["data-test"^="something"]) ==
               with_attr("div", "data-test", {:starts_with, "something"})
    end

    test "with attribute and {:ends_with, value}, check for attr ending with value" do
      assert ~s(input["type"$="text"]) == with_attr("input", "type", {:ends_with, "text"})

      assert ~s(div["data-test"$="something"]) ==
               with_attr("div", "data-test", {:ends_with, "something"})
    end

    test "with attribute and {:contains, value}, check for attr containing the value" do
      assert ~s(input["type"*="text"]) == with_attr("input", "type", {:contains, "text"})

      assert ~s(div["data-test"*="something"]) ==
               with_attr("div", "data-test", {:contains, "something"})
    end
  end

  for style <- ~w(map keyword)a do
    @style style
    describe "with_attrs/2 #{@style}" do
      test "with false, checks it does not contain the attr" do
        assert ~s/input:not(["checked"])/ ==
                 with_attrs("input", as(%{"checked" => false}, @style))
      end

      test "with true, checks that attribute is there" do
        assert ~s/input["checked"]/ == with_attrs("input", as(%{"checked" => true}, @style))
      end

      test "with just a value, check the attribute has that value" do
        assert ~s/input["type"="hidden"]/ ==
                 with_attrs("input", as(%{"type" => "hidden"}, @style))
      end

      test "with a complex value, behaves like with_attr/3" do
        assert ~s/input["class"~="hola"]/ ==
                 with_attrs("input", as(%{"class" => {:contains_word, "hola"}}, @style))
      end

      test "with a several attributes, checks everything" do
        assert ~s/input["class"~="hola"]["type"="hidden"]/ ==
                 with_attrs(
                   "input",
                   as(%{"class" => {:contains_word, "hola"}, "type" => "hidden"}, @style)
                 )
      end

      test "if there are any attributes with false and some with other values, the ones with false are at the end of the selector" do
        assert ~s/input["class"~="hola"]["type"="hidden"]:not(["data-test"]):not(["name"])/ ==
                 with_attrs(
                   "input",
                   as(
                     %{
                       "name" => false,
                       "class" => {:contains_word, "hola"},
                       "data-test" => false,
                       "type" => "hidden"
                     },
                     @style
                   )
                 )
      end
    end
  end

  defp as(:keyword), do: []
  defp as(:map), do: %{}
  defp as(enum, style), do: Enum.into(enum, as(style))
end
