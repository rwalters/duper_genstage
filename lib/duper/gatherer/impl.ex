#---
# Implementation component of Duper.Gatherer
#
# Inspired by the breakdown of Sequence into API, Server, and Impl
# (implementation)
#
#---
defmodule Duper.Gatherer.Impl do
  require Logger

  alias Duper.Results

  def done(worker_count), do: worker_count - 1

  def result(path, hash) do
    Results.add_hash_for(path, hash)
  end

  def report_results() do
    Logger.debug("report results")
    IO.puts "Results:\n"

    Results.find_duplicates()
    |> Enum.each(&IO.inspect/1)
  end
end
