defmodule NetCommon.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: NetCommon.ConnectionSupervisor },
      # Supervisor.child_spec({Task, fn -> EarthServer.open_port() end}, restart: :permanent)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
