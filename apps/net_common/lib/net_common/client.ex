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

    NetCommon.Connection.connect(connection, :server)

    # {:ok, queue} = DynamicSupervisor.start_child(
    #   NetCommon.Supervisor,
    #   {NetCommon.Queue, {}}
    # )

    queue = ""

    Agent.start_link(fn -> %{connection: connection, queue: queue} end, name: __MODULE__)
  end

  def ping() do
    # connection = Agent.get(__MODULE__, &Map.get(&1, :connection))

    # message = %NetCommon.Message{header: %NetCommon.Message.Header{id: 1}}
    # |> NetCommon.Message.put("ping")

    # NetCommon.Connection.send(connection, message)
  end
end