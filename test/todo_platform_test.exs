defmodule TodoPlatformTest do
  use ExUnit.Case
  doctest TodoPlatform

  test "should create new todolist" do
    assert TodoList.new != nil
  end

  test "returns empty list for non existing key" do
    empty_list = TodoList.new |> TodoList.entries(20)

    assert empty_list == []
  end

  test "add new item to todolist" do
    todo_with_one_entry = TodoList.new |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})

    assert TodoList.entries(todo_with_one_entry, {2013, 12, 19}) == [%{date: {2013, 12, 19}, title: "Dentist", id: 1}]
  end

  test "updated entry in todolist" do
    todo_with_one_entry = TodoList.new |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})

    todo_with_one_entry = TodoList.update_entry(todo_with_one_entry, 1, fn(entry) -> %{entry | title: "Updated Dentist"} end)

    assert TodoList.entries(todo_with_one_entry, {2013, 12, 19}) == [%{date: {2013, 12, 19}, title: "Updated Dentist", id: 1}]
  end

  test "delete entry from todolisy" do
    todo_with_two_entries =
      TodoList.new
      |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Shopping"})
      |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})

    todo_with_one_entry = TodoList.delete_entry(todo_with_two_entries, 1)

    assert TodoList.entries(todo_with_one_entry, {2013, 12, 19}) == [%{date: {2013, 12, 19}, title: "Dentist", id: 2}]
  end
  test "gets entries for given date" do
    todo_with_two_entries =
      TodoList.new
      |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Shopping"})
      |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})

    assert TodoList.entries(todo_with_two_entries, {2013, 12, 19}) == [%{date: {2013, 12, 19}, title: "Shopping", id: 1}, %{date: {2013, 12, 19}, title: "Dentist", id: 2}]
  end
end
