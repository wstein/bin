#!/usr/bin/env elixir

System.put_env("J2AS_TESTING", "true")
Code.require_file("../j2as", __DIR__)

ExUnit.start()

defmodule J2ASTest do
  use ExUnit.Case, async: true

  defp convert(jsonl, opts \\ %{contract?: true}) do
    J2AS.convert!(jsonl, opts)
  end

  defp run_cli(args, input) do
    path = Path.join(System.tmp_dir!(), "j2as-test-#{System.unique_integer([:positive])}.jsonl")
    File.write!(path, input)

    try do
      System.cmd("env", ["-u", "J2AS_TESTING", "elixir", "j2as" | args ++ [path]],
        stderr_to_stdout: true
      )
    after
      File.rm(path)
    end
  end

  describe "JSONL stream conversion" do
    test "renders one AION stream value per JSONL value with contract by default" do
      input = """
      "line1"
      2
      3
      [1,2,3]
      {"type":"test","desc":"this is test data"}
      """

      assert convert(input) ==
               """
               contract urn:aion:delimited-stream
               "line1"
               2
               3
               [1 2 3]
               {type test desc "this is test data"}
               """
               |> String.trim()
    end

    test "can omit the contract header" do
      assert convert("1\n2\n", %{contract?: false}) == "1\n2"
    end

    test "preserves object key order" do
      assert convert(~s|{"z":1,"a":2,"m":3}\n|, %{contract?: false}) == "{z 1 a 2 m 3}"
    end

    test "allows CRLF input and trims surrounding JSON value whitespace" do
      assert convert("  1  \r\n  [2,3]  \r\n", %{contract?: false}) == "1\n[2 3]"
    end

    test "rejects blank lines in the middle of the stream" do
      assert_raise JSON.DecodeError, ~r/blank line at JSONL line 2/, fn ->
        convert("1\n\n2\n")
      end
    end

    test "reports the failing JSONL line number" do
      assert_raise JSON.DecodeError, ~r/line 2: unexpected trailing content/, fn ->
        convert("1\n{}{}\n")
      end
    end
  end

  describe "AION delimited rendering" do
    test "quotes reserved and number-like strings while leaving ordinary words bare" do
      input = ~s|{"tag":"#release","kind":"record","literal":"true","num_as_text":"123"}\n|

      assert convert(input, %{contract?: false}) ==
               ~s|{tag #release kind record literal "true" num_as_text "123"}|
    end

    test "escapes JSON string edge cases" do
      input = ~S|{"quote":"a\"b","slash":"a\\b","tab":"a\tb","controls":"a\bb\fc\u0001d"}| <> "\n"

      assert convert(input, %{contract?: false}) ==
               ~s|{quote "a\\"b" slash a\\b tab "a\\u0009b" controls "a\\bb\\fc\\u0001d"}|
    end

    test "renders nested objects and arrays compactly" do
      input = ~s|{"outer":{"inner":[true,false,null,1.5]}}\n|

      assert convert(input, %{contract?: false}) ==
               "{outer {inner [true false null 1.5]}}"
    end
  end

  describe "CLI options" do
    test "defaults to contract output" do
      {output, 0} = run_cli([], "1\n")

      assert output == "contract urn:aion:delimited-stream\n1\n"
    end

    test "supports --no-contract" do
      {output, 0} = run_cli(["--no-contract"], "1\n")

      assert output == "1\n"
    end
  end
end
