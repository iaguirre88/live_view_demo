defmodule ElixirConsoleWeb.ConsoleTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query, only: [css: 1]

  @command_input css("#commandInput")
  @command_output css("#commandOutput")
  @suggestions_list css("#suggestions-list")

  feature "visitor can evaluate an expression", %{session: session} do
    session
    |> visit("/")
    |> fill_in(@command_input, with: "a = 1 + 2")
    |> send_keys([:enter])
    |> find(@command_output, fn output ->
      assert_text(output, "> a = 1 + 2")
      assert_text(output, "3")
    end)
    |> find(@command_input, fn input ->
      input
      |> has_value?("")
      |> assert
    end)
  end

  feature "visitor can get suggestions while typing", %{session: session} do
    session
    |> visit("/")
    |> fill_in(@command_input, with: "Enu")
    |> send_keys([:tab])
    |> find(@suggestions_list, fn suggestions_list ->
      assert_text(suggestions_list, "Enum\n")
      assert_text(suggestions_list, "Enumerable")
    end)
    |> fill_in(@command_input, with: "Enumer")
    |> send_keys([:tab])
    |> find(@command_input, fn input ->
      input
      |> has_value?("Enumerable")
      |> assert
    end)
  end
  feature "visitor can shortcut used expressions", %{session: session} do
    session
    |> visit("/")
    |> fill_in(css("#commandInput"), with: "a = 1 + 2")
    |> send_keys([:enter])
    |> send_keys([:up_arrow])
    |> find(css("#commandInput"), fn input ->
      input
      |> has_value?("a = 1 + 2")
      |> assert
    end)
  end
end
