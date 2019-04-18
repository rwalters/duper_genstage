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
  use GenServer

  @me Gatherer

  # api

  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def done() do
    GenServer.cast(@me, :done)
  end

  def result(path, hash) do
    GenServer.cast(@me, { :result, path, hash })
  end

  # server

  def init(worker_count) do
    Logger.debug("#{__MODULE__} Starting")

    # Process.send_after(self(), :kickoff, 0)
    { :ok, worker_count }
  end

  def handle_cast(:done, _worker_count = 1) do
    Logger.debug("...one worker left")
    report_results()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    Logger.debug("...processing workers")
    { :noreply, worker_count - 1 }
  end

  def handle_cast({:result, path, hash}, worker_count) do
    Logger.debug("handle results")
    Duper.Results.add_hash_for(path, hash)
    { :noreply, worker_count }
  end

  defp report_results() do
    Logger.debug("report results")
    IO.puts "Results:\n"
    Duper.Results.find_duplicates()
    |> Enum.each(&IO.inspect/1)
  end
end
