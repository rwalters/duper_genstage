#---
# Server component of Duper.Gather
#
# Inspired by the breakdown of Sequence into API, Server, and Impl
# (implementation)
#
#---
defmodule Duper.Gatherer.Server do
  require Logger
  use GenServer

  alias Duper.Gatherer.Impl

  def init(worker_count) do
    Logger.debug("#{__MODULE__} Starting")

    # This was used before I moved to GenStage...
    # Process.send_after(self(), :kickoff, 0)
    { :ok, worker_count }
  end

  def handle_cast(:done, _worker_count = 1) do
    Logger.debug("...one worker left")
    Impl.report_results()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    { :noreply, Impl.done(worker_count) }
  end

  def handle_cast({:result, path, hash}, worker_count) do
    Logger.debug("handle_cast :result")
    Impl.result(path, hash)
    { :noreply, worker_count }
  end
end
