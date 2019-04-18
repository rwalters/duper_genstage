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
        kafka: [stages: 2, batch_size: 100],
      ]
    )
  end
end
