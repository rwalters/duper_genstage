#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
defmodule Duper.Gatherer do
  require Logger

  @server Duper.Gatherer.Server

  def start_link(worker_count) do
    GenServer.start_link(@server, worker_count, name: @server)
  end

  def done() do
    GenServer.cast(@server, :done)
  end

  def result(path, hash) do
    GenServer.cast(@server, { :result, path, hash })
  end

  # server has been MOVED
  # It is now in Gatherer.Server
end
