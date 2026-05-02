#!/usr/bin/env elixir

System.put_env("J2AI_TESTING", "true")
Code.require_file("../j2ai", __DIR__)

ExUnit.start()

defmodule J2AITest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  defp opts(overrides) do
    Map.merge(%{width: 100, single_line_lists: true}, overrides)
  end

  defp convert(json, overrides \\ %{}) do
    J2AI.convert!(json, opts(overrides))
  end

  defp run_cli(args, input) do
    path = Path.join(System.tmp_dir!(), "j2ai-test-#{System.unique_integer([:positive])}.json")
    File.write!(path, input)

    try do
      System.cmd("env", ["-u", "J2AI_TESTING", "elixir", "j2ai" | args ++ [path]],
        stderr_to_stdout: true
      )
    after
      File.rm(path)
    end
  end

  describe "single-line lists" do
    test "renders scalar field lists on one line when they fit" do
      assert convert(~s|{"tags":["user","admin","a b c"]}|) ==
               "record\n  tags [user admin \"a b c\"]"
    end

    test "expands scalar field lists when disabled" do
      assert convert(~s|{"tags":["user","admin"]}|, %{single_line_lists: false}) ==
               "record\n  tags list\n    user\n    admin"
    end

    test "expands scalar field lists when they exceed width" do
      assert convert(~s|{"tags":["longvalue1","longvalue2","longvalue3"]}|, %{width: 40}) ==
               "record\n  tags list\n    longvalue1\n    longvalue2\n    longvalue3"
    end

    test "renders nested scalar lists on one line when they fit" do
      assert convert(~s|[["a","b"],["c","d"]]|) == "list\n  [a b]\n  [c d]"
    end

    test "keeps lists with nested objects expanded" do
      assert convert(~s|{"items":[{"id":1},{"id":2}]}|) ==
               "record\n  items list\n    record\n      id 1\n    record\n      id 2"
    end
  end

  describe "config parsing" do
    test "parses width, single_line_lists, and inline comments" do
      config = """
      width 80 # terminal-friendly
      single_line_lists false # always use blocks
      """

      assert J2AI.parse_config_text(config) == %{width: 80, single_line_lists: false}
    end

    test "invalid values warn and are ignored" do
      {result, stderr} =
        with_io(:stderr, fn ->
          J2AI.parse_config_text("width 39\nsingle_line_lists maybe")
        end)

      assert result == %{}
      assert stderr =~ "width must be an integer >= 40"
      assert stderr =~ "single_line_lists must be true/false/on/off/yes/no"
    end
  end

  describe "CLI options" do
    test "accepts --width N and --no-single-line-lists" do
      {output, 0} =
        run_cli(["--width", "80", "--no-single-line-lists"], ~s|{"tags":["a","b"]}|)

      assert output == "record\n  tags list\n    a\n    b\n"
    end

    test "accepts --width=N" do
      {output, 0} = run_cli(["--width=80"], ~s|{"tags":["a","b"]}|)

      assert output == "record\n  tags [a b]\n"
    end
  end
end
