defmodule DomHelpers.SelectorsTest do
  @moduledoc false
  use DomHelpers.Case

  import DomHelpers.Selectors

  describe "with_attr" do
    test "with just an attribute name, check that it has it" do
      assert "input[\"checked\"]" == with_attr("input", "checked")
      assert "div[\"data-test-hello\"]" == with_attr("div", "data-test-hello")
    end

    test "with attribute name and a plain value, check for equality" do
      assert "input[\"type\"=\"text\"]" == with_attr("input", "type", "text")
      assert "div[\"data-test\"=\"something\"]" == with_attr("div", "data-test", "something")
    end
  end
end
