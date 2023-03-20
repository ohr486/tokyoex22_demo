defmodule NPlusOne.N1Check.Handler do
  require Logger

  def handle_event([:n_plus_one, _, :query], _measurements, meta, _config) do
    #Logger.info("meta: #{inspect meta}")
    query = Map.get(meta, :query)
    #Logger.info(">>>>>>>>>> query: #{inspect query} <<<<<<<<<<")

    #{:ok, result} = Map.get(meta, :result)
    #rows = Map.get(result, :num_rows)
    #Logger.info(">>>>>>>>>> result-rows: #{inspect rows} <<<<<<<<<<")

    NPlusOne.N1Check.Detector.analyze(query)
  end
end
