defmodule TodoServer do
  use GenServer

  # public interface
  def start do
    GenServer.start(TodoServer, nil)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # genserver interface implementation
  def init(_) do
    {:ok, TodoList.new}
  end

  def handle_cast({:add_entry, entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, entry)}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {:reply, TodoList.entries(state, todo_list), todo_list}
  end

  #{:ok, todo_server} = TodoServer.start
  #TodoServer.add_entry(todo_server, %{date: {2013, 12, 19}, title: "Dentist"})
  #TodoServer.add_entry(todo_server, %{date: {2013, 12, 20}, title: "Shopping"})
  #TodoServer.add_entry(todo_server, %{date: {2013, 12, 19}, title: "Movies"})
  #TodoServer.entries(todo_server, {2013, 12, 19})
end
