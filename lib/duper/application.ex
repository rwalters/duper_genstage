#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
defmodule Duper.Application do
  @moduledoc false

  require Logger
  use Application

  alias Duper.{Gatherer, PathFinder, Results, Worker}

  def start(_type, _args) do
    Logger.debug("---- Application Starting ----")
    import Supervisor.Spec

    Logger.debug("Starting Gatherer")
    opts = [strategy: :one_for_one, name: Duper.GatherSupervisor]
    start_result = Supervisor.start_link([ Gatherer ], opts)
    Logger.debug(inspect(start_result))

    children = [
      Results,
      { PathFinder, Application.get_env(:duper, :root_path) },
    ]

    Logger.debug("Starting #{inspect(children)}")
    opts = [strategy: :rest_for_one, name: Duper.Supervisor]
    start_result = Supervisor.start_link(children, opts)
    Logger.debug(inspect(start_result))

    children = [
      worker(Worker, [], id: 1),
      worker(Worker, [], id: 2),
    ]

    Logger.debug("Starting #{inspect(children)}")
    opts = [strategy: :rest_for_one, name: Duper.GenStageWorkerSupervisor]
    start_result = Supervisor.start_link(children, opts)
    Logger.debug(inspect(start_result))

    {:ok, self()}
  end
end
