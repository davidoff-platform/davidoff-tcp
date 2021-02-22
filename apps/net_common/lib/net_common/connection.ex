defmodule NetCommon.Connection do
  use Agent

  def start_link(socket) do
    Agent.start_link(fn -> %{socket: socket} end)
  end

  def connect_to_client(connection) do
    #if (m_nOwnerType == owner::server)

    DynamicSupervisor.start_child(
      NetCommon.ConnectionSupervisor,
      {Task, fn -> NetCommon.Connection.read_header(connection) end}
    )
  end

  def connect_to_server(connection) do
    #if (m_nOwnerType == owner::server)

    DynamicSupervisor.start_child(
      NetCommon.ConnectionSupervisor,
      {Task, fn -> NetCommon.Connection.read_header(connection) end}
    )
  end

  def id(connection) do
    inspect connection
  end

  def socket(connection) do
    Agent.get(connection, &Map.get(&1, :socket))
  end

  def read_header(connection) do
    IO.inspect("Reading header")

    case :gen_tcp.recv(connection |> socket, 0) do
      {:ok, data} -> read_body(connection, data)
      _ -> nil # close socket
    end
  end

  def read_body(connection, header) do
    IO.inspect("Header:")
    IO.inspect(header)

    case :gen_tcp.recv(connection |> socket, 0) do
      {:ok, data} -> add_to_incoming_message_queue(connection, data)
      _ -> nil # close socket
    end
  end

  def add_to_incoming_message_queue(connection, message) do
    IO.inspect("Body:")
    IO.inspect(message)

    Process.sleep 1000

    read_header(connection)
  end


  def send(connection, data) do
    :ok = :gen_tcp.send(connection |> socket, data)
  end
end