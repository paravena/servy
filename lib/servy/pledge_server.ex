defmodule Servy.PledgeServer do
  @name :pledge_server
  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledged() do
    GenServer.call(@name, :total_pledged)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  # Server Callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = state.pledges |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = state.pledges |> Enum.take(state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    {:noreply, %{state | cache_size: size}}
  end

  def handle_info(message, state) do
    IO.puts("Can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # Send the pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
