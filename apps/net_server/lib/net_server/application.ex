defmodule NetServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :observer.start()

    children = [
      NetCommon.Supervisor,
      {NetCommon.Server, port: 5000},
    ]

    opts = [strategy: :one_for_one, name: NetServer.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
