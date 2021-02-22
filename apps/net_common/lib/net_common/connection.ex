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
    case :gen_tcp.recv(connection |> socket, 83) do
      {:ok, data} -> read_body(connection, data)
      _ -> nil # close socket
    end
  end

  def read_body(connection, data) do
    header = data |> :erlang.binary_to_term()

    case :gen_tcp.recv(connection |> socket, header.size) do
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
    :ok = :gen_tcp.send(connection |> socket, data.header |> :erlang.term_to_binary())
    :ok = :gen_tcp.send(connection |> socket, data |> :erlang.term_to_binary())
    :ok
  end
end