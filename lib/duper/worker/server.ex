#---
# Server component of Duper.Worker
#
# Inspired by the breakdown of Sequence into API, Server, and Impl
# (implementation) in Programming Elixir 1.6
#
#---
defmodule Duper.Worker.Server do
  require Logger

  use GenStage, restart: :transient

  alias Duper.PathFinder
  alias Duper.Worker.Impl

  @impl true
  def init(:no_args) do
    Logger.debug("#{__MODULE__} Starting")

    {:consumer, :ok, subscribe_to: [PathFinder]}
  end

  @impl true
  def handle_events(paths, _from, state) do
    Logger.debug("-> handle_events <-\n#{inspect(paths)}\n#{inspect(state)}")

    for path <- paths do
      path
      |> Impl.add_result()
    end

    {:noreply, [], state}
  end
end
