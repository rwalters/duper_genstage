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

  def start(_type, _args) do
    Logger.debug("---- Application Starting ----")

    children = [
      { Duper, [] },
    ]

    opts = [strategy: :one_for_one, name: Duper.Supervisor]
    start_result = Supervisor.start_link(children, opts)
    Logger.debug(inspect(start_result))

    {:ok, self()}
  end
end
