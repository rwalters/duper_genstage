#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
defmodule Duper do
  @moduledoc """
  Documentation for Duper.
  """

  require Logger
  use Broadway
  alias Broadway.Message

  @doc """
  Hello world.

  ## Examples

      iex> Duper.hello
      :world

  """
  def hello do
    :world
  end

  def start_link(opts) do
    Logger.debug("#{__MODULE__} Starting -- #{inspect(opts)}")

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producers: [
        default: [
          module: {Duper.Pathfinder, opts},
          stages: 1,
          transformer: {__MODULE__, :transform, []},
        ]
      ],
      processors: [
        default: [stages: 10],
      ],
      batchers: [
        default: [stages: 2, batch_size: 100],
      ]
    )
  end

  def handle_message(_processor_name, path, _context) do
    Logger.debug(" -> handle_message: #{path} <- ")
    path
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:default)
  end

  def handle_batch(:default, messages, _batch_info, _context) do
    IO.inspect(messages)
  end

  def transform(path, _opts) do
    Logger.debug(" -> transform: #{path} <- ")
    %Message{
      data: path,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def process_data(path) do
    Logger.debug(" -> process_data: #{path} <- ")
    %{Duper.Worker.Impl.hash_of_file_at(path) => path }
  end
end
