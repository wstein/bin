#!/usr/bin/env elixir

# Load the module without executing main().
System.put_env("J2AD_TESTING", "true")
Code.require_file("j2ad", __DIR__)

ExUnit.start()

defmodule J2ADTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  # ---------------------------------------------------------------------------
  # Helpers
  # ---------------------------------------------------------------------------

  defp opts(overrides \\ %{}) do
    Map.merge(
      %{pretty?: false, width: 100, object_threshold: 3, expand_lists: true},
      overrides
    )
  end

  defp compact(json), do: J2AD.convert!(json, opts())

  defp pretty(json, overrides \\ %{}),
    do: J2AD.convert!(json, opts(Map.merge(%{pretty?: true}, overrides)))

  # ---------------------------------------------------------------------------
  # Compact: objects
  # ---------------------------------------------------------------------------

  describe "compact – objects" do
    test "simple key–value pairs" do
      assert compact(~s|{"name":"Tom","age":100}|) == "{name Tom age 100}"
    end

    test "string value requiring quotes" do
      assert compact(~s|{"key":"hello world"}|) == ~s|{key "hello world"}|
    end

    test "boolean and null values render as atoms" do
      assert compact(~s|{"a":true,"b":false,"c":null}|) == "{a true b false c null}"
    end

    test "reserved words as keys are quoted" do
      assert compact(~s|{"true":1,"null":2}|) == ~s|{"true" 1 "null" 2}|
    end

    test "integer and float values" do
      assert compact(~s|{"i":42,"f":3.14}|) == "{i 42 f 3.14}"
    end

    test "nested object" do
      assert compact(~s|{"outer":{"inner":1}}|) == "{outer {inner 1}}"
    end

    test "empty object" do
      assert compact("{}") == "{}"
    end

    test "insertion order is preserved" do
      assert compact(~s|{"z":1,"a":2,"m":3}|) == "{z 1 a 2 m 3}"
    end
  end

  # ---------------------------------------------------------------------------
  # Compact: arrays
  # ---------------------------------------------------------------------------

  describe "compact – arrays" do
    test "list of scalars" do
      assert compact("[1,2,3]") == "[1 2 3]"
    end

    test "strings with spaces are quoted" do
      assert compact(~s|["a b","c"]|) == ~s|["a b" c]|
    end

    test "nested lists" do
      assert compact("[[1,2],[3,4]]") == "[[1 2] [3 4]]"
    end

    test "list of objects" do
      assert compact(~s|[{"k":1},{"k":2}]|) == "[{k 1} {k 2}]"
    end

    test "empty list" do
      assert compact("[]") == "[]"
    end
  end

  # ---------------------------------------------------------------------------
  # Compact: root scalars
  # ---------------------------------------------------------------------------

  describe "compact – root scalars" do
    test "integer" do
      assert compact("42") == "42"
    end

    test "boolean" do
      assert compact("true") == "true"
      assert compact("false") == "false"
    end

    test "null" do
      assert compact("null") == "null"
    end

    test "atom string" do
      assert compact(~s|"hello"|) == "hello"
    end

    test "quoted string (contains space)" do
      assert compact(~s|"hello world"|) == ~s|"hello world"|
    end
  end

  # ---------------------------------------------------------------------------
  # Pretty: basic layout
  # ---------------------------------------------------------------------------

  describe "pretty – basic layout" do
    test "root object always expands" do
      assert pretty(~s|{"x":1}|) == "{\n  x 1\n}"
    end

    test "all scalar types stay on the same line as their key" do
      assert pretty(~s|{"a":1,"b":true,"c":null,"d":"text"}|) ==
               "{\n  a 1\n  b true\n  c null\n  d text\n}"
    end

    test "empty root object" do
      assert pretty("{}") == "{}"
    end

    test "empty root list" do
      assert pretty("[]") == "[]"
    end

    test "root scalar" do
      assert pretty("42") == "42"
      assert pretty("true") == "true"
    end
  end

  # ---------------------------------------------------------------------------
  # Pretty: object expansion heuristic
  # ---------------------------------------------------------------------------

  describe "pretty – object expansion heuristic" do
    test "2-field nested object stays compact (below default threshold of 3)" do
      assert pretty(~s|{"outer":{"x":1,"y":2}}|) == "{\n  outer {x 1 y 2}\n}"
    end

    test "3-field nested object expands (meets default threshold)" do
      assert pretty(~s|{"outer":{"x":1,"y":2,"z":3}}|) ==
               "{\n  outer {\n    x 1\n    y 2\n    z 3\n  }\n}"
    end

    test "object-threshold=0 disables the heuristic; fits → compact" do
      assert pretty(~s|{"outer":{"x":1,"y":2,"z":3}}|, %{object_threshold: 0}) ==
               "{\n  outer {x 1 y 2 z 3}\n}"
    end

    test "object-threshold=2 causes 2-field nested objects to expand" do
      assert pretty(~s|{"outer":{"x":1,"y":2}}|, %{object_threshold: 2}) ==
               "{\n  outer {\n    x 1\n    y 2\n  }\n}"
    end

    test "opening brace stays on the same line as the key" do
      result = pretty(~s|{"addr":{"a":1,"b":2,"c":3}}|)
      assert String.contains?(result, "addr {\n")
      refute String.contains?(result, "addr \n{")
    end
  end

  # ---------------------------------------------------------------------------
  # Pretty: list expansion heuristic
  # ---------------------------------------------------------------------------

  describe "pretty – list expansion heuristic" do
    test "list of scalars stays compact" do
      assert pretty(~s|{"tags":["a","b","c"]}|) == "{\n  tags [a b c]\n}"
    end

    test "list of objects expands even when the compact form fits within width" do
      assert pretty(~s|{"items":[{"k":1},{"k":2}]}|) ==
               "{\n  items [\n    {k 1}\n    {k 2}\n  ]\n}"
    end

    test "opening bracket stays on the same line as the key" do
      result = pretty(~s|{"items":[{"k":1},{"k":2}]}|)
      assert String.contains?(result, "items [\n")
      refute String.contains?(result, "items \n[")
    end

    test "expand-lists=false keeps list of objects compact when it fits" do
      result = pretty(~s|{"items":[{"k":1},{"k":2}]}|, %{expand_lists: false})
      assert result =~ "[{k 1} {k 2}]"
    end

    test "list with any non-scalar element expands" do
      result = pretty(~s|{"mixed":[1,{"k":2}]}|)
      assert result =~ "[\n"
    end
  end

  # ---------------------------------------------------------------------------
  # Pretty: width-based expansion
  # ---------------------------------------------------------------------------

  describe "pretty – width-based expansion" do
    test "nested 2-field object expands when compact form exceeds width" do
      # compact child is "{longkey1 longvalue1 longkey2 longvalue2}" = 41 chars
      # at level 1 with "outer " prefix: 41 + 2 + 6 = 49 > 40
      result =
        pretty(
          ~s|{"outer":{"longkey1":"longvalue1","longkey2":"longvalue2"}}|,
          %{width: 40, object_threshold: 0}
        )

      assert String.contains?(result, "outer {\n")
    end

    test "list stays compact when it fits within a narrow width" do
      assert pretty(~s|{"x":[1,2]}|, %{width: 40}) == "{\n  x [1 2]\n}"
    end
  end

  # ---------------------------------------------------------------------------
  # Pretty: canonical example
  # ---------------------------------------------------------------------------

  describe "pretty – canonical example" do
    test "produces expected output for the JSON person example" do
      input = ~s|{
        "first_name": "John",
        "last_name": "Smith",
        "is_alive": true,
        "age": 27,
        "address": {
          "street_address": "21 2nd Street",
          "city": "New York",
          "state": "NY",
          "postal_code": "10021-3100"
        },
        "phone_numbers": [
          {"type": "home", "number": "212 555-1234"},
          {"type": "office", "number": "646 555-4567"}
        ],
        "children": ["Catherine", "Thomas", "Trevor"],
        "spouse": null
      }|

      expected = """
      {
        first_name John
        last_name Smith
        is_alive true
        age 27
        address {
          street_address "21 2nd Street"
          city "New York"
          state NY
          postal_code 10021-3100
        }
        phone_numbers [
          {type home number "212 555-1234"}
          {type office number "646 555-4567"}
        ]
        children [Catherine Thomas Trevor]
        spouse null
      }
      """

      assert pretty(input) == String.trim(expected)
    end
  end

  # ---------------------------------------------------------------------------
  # Config parsing: valid entries
  # ---------------------------------------------------------------------------

  describe "parse_config_text – valid entries" do
    test "width" do
      assert J2AD.parse_config_text("width 80") == %{width: 80}
    end

    test "width at the minimum boundary" do
      assert J2AD.parse_config_text("width 40") == %{width: 40}
    end

    test "object_threshold" do
      assert J2AD.parse_config_text("object_threshold 5") == %{object_threshold: 5}
    end

    test "object_threshold 0 (disables the heuristic)" do
      assert J2AD.parse_config_text("object_threshold 0") == %{object_threshold: 0}
    end

    test "expand_lists accepts all boolean spellings" do
      for word <- ~w[true on yes 1] do
        assert J2AD.parse_config_text("expand_lists #{word}") == %{expand_lists: true},
               "expected expand_lists: true for #{inspect(word)}"
      end

      for word <- ~w[false off no 0] do
        assert J2AD.parse_config_text("expand_lists #{word}") == %{expand_lists: false},
               "expected expand_lists: false for #{inspect(word)}"
      end
    end

    test "pretty" do
      assert J2AD.parse_config_text("pretty true") == %{pretty?: true}
      assert J2AD.parse_config_text("pretty false") == %{pretty?: false}
    end

    test "multiple entries are all applied" do
      result = J2AD.parse_config_text("width 80\nobject_threshold 5")
      assert result == %{width: 80, object_threshold: 5}
    end

    test "# comments are ignored" do
      assert J2AD.parse_config_text("# comment\nwidth 80\n# another") == %{width: 80}
    end

    test "blank lines are ignored" do
      assert J2AD.parse_config_text("\n\nwidth 80\n\n") == %{width: 80}
    end

    test "returns empty map when all lines are comments or blank" do
      assert J2AD.parse_config_text("# nothing here\n\n") == %{}
    end
  end

  # ---------------------------------------------------------------------------
  # Config parsing: invalid entries warn and are ignored
  # ---------------------------------------------------------------------------

  describe "parse_config_text – invalid entries warn and are ignored" do
    test "non-integer width" do
      {result, stderr} = with_io(:stderr, fn -> J2AD.parse_config_text("width banana") end)
      assert result == %{}
      assert stderr =~ "width must be an integer >= 40"
    end

    test "width below minimum (39)" do
      {result, stderr} = with_io(:stderr, fn -> J2AD.parse_config_text("width 39") end)
      assert result == %{}
      assert stderr =~ "width must be an integer >= 40"
    end

    test "negative object_threshold" do
      {result, stderr} =
        with_io(:stderr, fn -> J2AD.parse_config_text("object_threshold -1") end)

      assert result == %{}
      assert stderr =~ "object_threshold must be a non-negative integer"
    end

    test "non-integer object_threshold" do
      {result, stderr} =
        with_io(:stderr, fn -> J2AD.parse_config_text("object_threshold x") end)

      assert result == %{}
      assert stderr =~ "object_threshold must be a non-negative integer"
    end

    test "invalid expand_lists value" do
      {result, stderr} =
        with_io(:stderr, fn -> J2AD.parse_config_text("expand_lists maybe") end)

      assert result == %{}
      assert stderr =~ "expand_lists must be true/false/on/off/yes/no"
    end

    test "invalid pretty value" do
      {result, stderr} = with_io(:stderr, fn -> J2AD.parse_config_text("pretty yep") end)
      assert result == %{}
      assert stderr =~ "pretty must be true/false/on/off/yes/no"
    end

    test "unknown key" do
      {result, stderr} =
        with_io(:stderr, fn -> J2AD.parse_config_text("unknown_key val") end)

      assert result == %{}
      assert stderr =~ "unknown key"
    end

    test "malformed line (no value token)" do
      {result, stderr} = with_io(:stderr, fn -> J2AD.parse_config_text("no_value") end)
      assert result == %{}
      assert stderr =~ "malformed line"
    end

    test "invalid entries do not affect surrounding valid entries" do
      {result, _stderr} =
        with_io(:stderr, fn ->
          J2AD.parse_config_text("width 80\nexpand_lists maybe\nobject_threshold 2")
        end)

      assert result == %{width: 80, object_threshold: 2}
    end
  end

  # ---------------------------------------------------------------------------
  # Atom quoting
  # ---------------------------------------------------------------------------

  describe "atom quoting" do
    test "empty string is always quoted" do
      assert compact(~s|{"k":""}|) == ~s|{k ""}|
    end

    test "strings with spaces are quoted" do
      assert compact(~s|{"k":"a b c"}|) == ~s|{k "a b c"}|
    end

    test "strings with { are quoted" do
      assert compact(~s|{"k":"a{b"}|) == ~s|{k "a{b"}|
    end

    test "strings with [ are quoted" do
      assert compact(~s|{"k":"a[b"}|) == ~s|{k "a[b"}|
    end

    test "double quotes in values are backslash-escaped" do
      # JSON value: a"b  →  AION atom: "a\"b"
      assert compact(~S|{"k":"a\"b"}|) == ~s|{k "a\\"b"}|
    end

    test "backslash in a bare atom passes through as-is" do
      # JSON value a\b — backslash is not a delimiter, so no quoting is needed.
      assert compact(~S|{"k":"a\\b"}|) == ~s|{k a\\b}|
    end

    test "control characters are escaped" do
      assert compact(~S|{"k":"a\nb"}|) == ~s|{k "a\\nb"}|
      assert compact(~S|{"k":"a\tb"}|) == ~s|{k "a\\tb"}|
    end
  end

  # ---------------------------------------------------------------------------
  # Invalid JSON
  # ---------------------------------------------------------------------------

  describe "invalid JSON" do
    test "raises JSON.DecodeError on malformed input" do
      assert_raise JSON.DecodeError, fn -> J2AD.convert!("{bad}", opts()) end
    end

    test "raises JSON.DecodeError on trailing content" do
      assert_raise JSON.DecodeError, fn -> J2AD.convert!(~s|{}{}|, opts()) end
    end

    test "raises JSON.DecodeError on truncated input" do
      assert_raise JSON.DecodeError, fn -> J2AD.convert!(~s|{"k":|, opts()) end
    end
  end
end
