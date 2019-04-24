#---
# Impl component of Duper.Worker
#
# Inspired by the breakdown of Sequence into API, Server, and Impl
# (implementation) in Programming Elixir 1.6
#
#---
defmodule Duper.Results.Impl do
  require Logger

  def update_results(results, key, new_value) do
    Logger.debug("update_results\n #{inspect(results)}\n #{key}\n #{new_value}")

    Map.update(
      results,        # look in this map
      key,            # for an entry with key
      [ new_value ],  # if not found, store this value
      fn existing ->  # else update with result of this fn
        [ new_value | existing ]
      end
    )
  end

  def duplicate_files(results) do
    Logger.debug("update_results\n #{inspect(results)}")
    results
    |> Enum.filter(fn { _hash, paths } -> length(paths) > 1 end)
    |> Enum.map(&elem(&1, 1))
  end
end
