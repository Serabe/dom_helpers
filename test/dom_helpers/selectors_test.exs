defmodule DomHelpers.SelectorsTest do
  @moduledoc false
  use DomHelpers.Case

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
end
