defmodule NetCommon.Server do
  require Logger

  def child_spec(opts) do
    %{id: NetCommon.Server, start: {NetCommon.Server, :start_link, [opts]}}
  end

  def start_link([ port: port ]) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    Logger.info("[SERVER] Started at port #{port}")

    Task.start_link(fn -> NetCommon.Server.wait_for_client_connection(socket, []) end)
  end

  def wait_for_client_connection(socket, connections) do
    {:ok, client_socket} = :gen_tcp.accept(socket)

    Logger.info("[SERVER] New Connection: #{inspect client_socket}")

    {:ok, connection} =
        DynamicSupervisor.start_child(
          NetCommon.ConnectionSupervisor,
          {NetCommon.Connection, client_socket}
        )

    if on_client_connect(connection) do
      :ok = :gen_tcp.controlling_process(client_socket, connection)

      NetCommon.Connection.connect_to_client(connection)

      Logger.info("[#{NetCommon.Connection.id(connection)}] Connection Approved")

      NetCommon.Connection.send(connection, "Welcome")

      wait_for_client_connection(socket, connections ++ [connection])
    else
      Logger.info("[-----] Connection denied")
      wait_for_client_connection(socket, connections)
    end
  end

  # connections

  # Stop

  # MessageClient
  # MessageAllClients (ignore some client)

  # OnClientConnect
  def on_client_connect(connection) do
    true
  end


  # OnClientDisconnect
  # OnMessage

  # queue
end