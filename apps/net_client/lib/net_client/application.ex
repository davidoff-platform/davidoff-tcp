defmodule NetClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      NetCommon.Supervisor,
      {NetCommon.Client, %{ host: {127, 0, 0, 1}, port: 5000 }},
      # {Task, fn ->
      #   Enum.each([1,2,4,5,6,7,8,100], fn n ->
      #     Process.sleep(2000)

      #     Logger.info("ping #{n}")
      #     NetCommon.Client.ping
      #   end)
      # end}
    ]

    opts = [strategy: :one_for_one, name: NetClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
