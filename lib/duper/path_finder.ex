#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
defmodule Duper.PathFinder do
  require Logger
  use GenStage

  @me PathFinder

  def start_link(root) do
    GenStage.start_link(__MODULE__, root, name: @me)
  end

  @impl true
  def init(path) do
    Logger.debug("#{__MODULE__} Starting")

    {:ok, dir_walker} = DirWalker.start_link(path)

    {:producer, dir_walker}
  end

  @impl true
  def handle_demand(demand, dir_walker) when demand > 0 do
    Logger.debug("-> handle_demand <-")
    paths = DirWalker.next(dir_walker, demand)

    {:noreply, paths, dir_walker}
  end
end
