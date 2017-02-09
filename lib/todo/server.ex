defmodule Todo.Server do
  use GenServer

  # public interface
  def start(name) do
    GenServer.start(Todo.Server, name)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # genserver interface implementation
  def init(name) do
    {:ok, {name, Todo.Database.get(name) || TodoList.new}}
  end

  def handle_cast({:add_entry, entry}, {name, todo_list}) do
    new_state = TodoList.add_entry(todo_list, entry)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, TodoList.entries(todo_list, date), {name, todo_list}}
  end

  # {:ok, todo_server} = Todo.Server.start("Bob_list")
  # Todo.Server.add_entry(todo_server, %{date: {2013, 12, 19}, title: "Dentist"})
  # Todo.Server.add_entry(todo_server, %{date: {2013, 12, 20}, title: "Shopping"})
  # Todo.Server.add_entry(todo_server, %{date: {2013, 12, 19}, title: "Movies"})
  # Todo.Server.entries(todo_server, {2013, 12, 19})
end
