defmodule NPlusOne.N1Check.Detector do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{query: nil, counter: 0}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:check, query}, _from, %{query: query, counter: counter} = state) do
    {:reply, {:match, query, counter + 1}, Map.put(state, :counter, counter + 1)}
  end

  @impl true
  def handle_call({:check, query}, _from, %{query: previous_query, counter: previous_count}) do
    {:reply, {:no_match, previous_query, previous_count}, %{query: query, counter: 1}}
  end

  @impl true
  def handle_call(:reset, _from, %{query: previous_query, counter: previous_count}) do
    {:reply, {:no_match, previous_query, previous_count}, %{query: nil, counter: 0}}
  end


  def check("SELECT" <> _rest = query) do
    GenServer.call(__MODULE__, {:check, query})
  end

  def check(_query) do
    GenServer.call(__MODULE__, :reset)
  end

  def analyze(query) do
    case check(query) do
      {:match, query, count} ->
        :nothing
      {:no_match, previous_query, count} ->
        if count > 2 do
          IO.puts "==========> n+1 SQL query detected!"
          IO.puts "            query: #{previous_query}"
          IO.puts "            called: #{count} times"
        end
    end
  end
end
