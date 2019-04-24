#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
defmodule Duper.Results do
  require Logger
  use GenServer

  @me __MODULE__


  # API

  def start_link(_) do
    Logger.debug("#{__MODULE__} Starting")
    GenServer.start_link(__MODULE__, :no_args, name: @me)
  end

  def add_hash_for(path, hash) do
    GenServer.cast(@me, { :add, path, hash })
  end

  def find_duplicates() do
    GenServer.call(@me, :find_duplicates)
  end

  # Server

  def init(:no_args) do
    Logger.debug("#{__MODULE__} Starting")

    { :ok, %{} }
  end

  def handle_cast({ :add, path, hash }, results) do
    Logger.debug("add path: #{inspect(path)}")
    results =
      Map.update(
        results,          # look in this map
        hash,             # for an entry with key
        [ path ],         # if not found, store this value
        fn existing ->    # else update with result of this fn
          [ path | existing ]
        end)
    { :noreply, results }
  end

  def handle_call(:find_duplicates, _from, results) do
    Logger.debug("find dupes")
    {
      :reply,
      hashes_with_more_than_one_path(results),
      results
    }
  end

  defp hashes_with_more_than_one_path(results) do
    results
    |> Enum.filter(fn { _hash, paths } -> length(paths) > 1 end)
    |> Enum.map(&elem(&1, 1))
  end
end
