#---
# Excerpted from "Programming Elixir ≥ 1.6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/elixir16 for more book information.
#---
# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :duper, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:duper, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :logger, backends: [:console]
config :logger, :console,
  level: :info,
  format: "[$level] $levelpad$dateT$time\n  $metadata\n  $message\n",
  metadata: [:function, :file, :line]

config :duper, root_path: System.get_env("ROOT_PATH") || "/app/paths"

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
