defmodule NetCommon.Client do
  use Agent

  # Connect
  # Disconnect
  # is connected? # check connection
  # owmned messages queue

  # connection

  # disconect on destroying

  def start_link(%{host: host, port: port}) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, packet: :raw, active: false, reuseaddr: true])

    {:ok, connection} =
        DynamicSupervisor.start_child(
          NetCommon.ConnectionSupervisor,
          {NetCommon.Connection, socket}
        )

    NetCommon.Connection.connect_to_server(connection)

    # {:ok, queue} = DynamicSupervisor.start_child(
    #   NetCommon.Supervisor,
    #   {NetCommon.Queue, {}}
    # )

    queue = ""

    Agent.start_link(fn -> %{connection: connection, queue: queue} end, name: __MODULE__)
  end

  def ping() do
    connection = Agent.get(__MODULE__, &Map.get(&1, :connection))

    NetCommon.Connection.send(connection, "ping")
  end
end