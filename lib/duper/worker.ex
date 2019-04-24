#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
defmodule Duper.Worker do
  require Logger

  use GenStage, restart: :transient

  def start_link(_) do
    GenStage.start_link(__MODULE__, :no_args)
  end
  def start_link(), do: start_link(:ok)


  @impl true
  def init(:no_args) do
    Logger.debug("#{__MODULE__} Starting")

    {:consumer, :ok, subscribe_to: [PathFinder]}
  end

  @impl true
  def handle_events(paths, _from, state) do
    Logger.debug("-> handle_events <-\n#{inspect(paths)}\n#{inspect(state)}\n")
    for path <- paths do
      path
      |> add_result()
    end

    {:noreply, [], state}
  end

  defp add_result(nil) do
    Logger.info("-> add_result <-\ndone")
    Duper.Gatherer.done()
    {:stop, :normal, nil}
  end

  defp add_result(path) do
    Logger.debug("-> add_result <-\n#{inspect(path)}")
    Duper.Gatherer.result(path, hash_of_file_at(path))

    { :noreply, [] }
  end

  defp hash_of_file_at(path) do
    File.stream!(path, [], 1024*1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn (block, hash) ->
        :crypto.hash_update(hash, block)
      end)
    |> :crypto.hash_final()
  end
end
