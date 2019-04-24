#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---

defmodule Duper.ResultsTest do
  use ExUnit.Case
  alias Duper.Results.Impl, as: Results

  test "can add entries to the results" do

    results = %{}
    results = results |> Results.update_results(123, "path1")
    results = results |> Results.update_results(456, "path2")
    results = results |> Results.update_results(123, "path3")
    results = results |> Results.update_results(789, "path4")
    results = results |> Results.update_results(456, "path5")
    results = results |> Results.update_results(999, "path6")

    duplicates = Results.duplicate_files(results)

    assert length(duplicates) == 2

    assert ~w{path3 path1} in duplicates
    assert ~w{path5 path2} in duplicates
  end
end
