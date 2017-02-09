defmodule Todo.Cache do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  def init(_) do
    Todo.Database.start("persist")
    {:ok, Map.new}
  end

  def handle_call({:server_process, todo_list_name}, _caller, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}
      :error ->
        {:ok, new_server} = Todo.Server.start(todo_list_name)
        {:reply, new_server, Map.put(todo_servers, todo_list_name, new_server)}
    end
  end

  #   {:ok, cache} = Todo.Cache.start
  #   Todo.Cache.server_process(cache, "bob_list")
  #   Todo.Cache.server_process(cache, "alice_list")
  #   bobs_list = Todo.Cache.server_process(cache, "bob_list")
  #   Todo.Server.add_entry(bobs_list, %{date: {2013, 12, 19}, title: "Dentist"})
  #   Todo.Server.entries(bobs_list, {2013, 12, 19})
  #   Todo.Cache.server_process(cache, "Alice's list") |> Todo.Server.entries({2013, 12, 19})
end
