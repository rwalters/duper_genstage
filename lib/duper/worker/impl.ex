#---
# Implementation component of Duper.Worker
#
# Inspired by the breakdown of Sequence into API, Server, and Impl
# (implementation) in Programming Elixir 1.6
#
#---
defmodule Duper.Worker.Impl do
  def add_result(nil) do
    Duper.Gatherer.done()
  end

  def add_result(path) do
    Duper.Gatherer.result(path, hash_of_file_at(path))
  end

  def hash_of_file_at(path) do
    File.stream!(path, [], 1024*1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn (block, hash) ->
        :crypto.hash_update(hash, block)
      end)
    |> :crypto.hash_final()
  end
end
