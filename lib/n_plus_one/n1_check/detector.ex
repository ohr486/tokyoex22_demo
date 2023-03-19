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
  # 引数のクエリが直前のクエリと同じ
  def handle_call({:check, query}, _from, %{query: query, counter: counter} = state) do
    {:reply, {:match, query, counter + 1}, Map.put(state, :counter, counter + 1)}
  end

  @impl true
  # 引数のクエリが直前のクエリと異なる
  def handle_call({:check, query}, _from, %{query: prev_query, counter: prev_count}) do
    {:reply, {:no_match, prev_query, prev_count}, %{query: query, counter: 1}}
  end

  @impl true
  def handle_call(:reset, _from, %{query: prev_query, counter: prev_count}) do
    {:reply, {:no_match, prev_query, prev_count}, %{query: nil, counter: 0}}
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
      {:no_match, prev_query, prev_count} ->
        # 同じクエリが複数回実行されている
        if prev_count > 1 do
          IO.puts "==========> n+1 SQL query detected!"
          IO.puts "            query: #{prev_query}"
          IO.puts "            called: #{prev_count} times"
        end
    end
  end
end
