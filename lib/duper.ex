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
    Logger.info("#{__MODULE__} Starting")

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
    path
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:s3)
  end

  def handle_batch(:default, messages, _batch_info, _context) do
    IO.inspect(messages)
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def process_data(path) do
    File.stream!(path, [], 1024*1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn (block, hash) ->
        :crypto.hash_update(hash, block)
      end)
    |> :crypto.hash_final()
  end
end
