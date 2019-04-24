#---
# Server component of Duper.Worker
#
# Inspired by the breakdown of Sequence into API, Server, and Impl
# (implementation) in Programming Elixir 1.6
#
#---
defmodule Duper.Results.Server do
  require Logger
  use GenServer

  alias Duper.Results.Impl

  def init(:no_args) do
    Logger.debug("#{__MODULE__} Starting")

    { :ok, %{} }
  end

  def handle_cast({ :add, path, file_hash }, results) do
    Logger.debug("add result")

    results =
      results
      |> Impl.update_results(file_hash, path)

    { :noreply, results }
  end

  def handle_call(:find_duplicates, _from, results) do
    Logger.debug("find dupes")

    {
      :reply,
      Impl.duplicate_files(results),
      results
    }
  end
end
