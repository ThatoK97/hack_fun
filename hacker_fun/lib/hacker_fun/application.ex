defmodule HackerFun.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HackerFun.Worker.start_link(arg)
      # {HackerFun.Worker, arg}
      {}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HackerFun.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
