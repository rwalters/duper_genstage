#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
defmodule Duper.Results do
  require Logger

  @server Duper.Results.Server

  # API

  def start_link(_) do
    GenServer.start_link(@server, :no_args, name: @server)
  end

  def add_hash_for(path, hash) do
    GenServer.cast(@server, { :add, path, hash })
  end

  def find_duplicates() do
    GenServer.call(@server, :find_duplicates)
  end

  # Server and Impl contain the rest of the code
end
