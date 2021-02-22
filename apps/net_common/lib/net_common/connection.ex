defmodule NetCommon.Connection do
  use Agent

  def start_link(socket) do
    Agent.start_link(fn -> %{socket: socket} end)
  end

  def connect(connection, :client) do
    DynamicSupervisor.start_child(
      NetCommon.ConnectionSupervisor,
      {Task, fn -> NetCommon.Connection.read_header(connection) end}
    )
  end

  def connect(connection, :server) do
    DynamicSupervisor.start_child(
      NetCommon.ConnectionSupervisor,
      {Task, fn -> NetCommon.Connection.write_validation(connection) end}
    )
  end

  def write_validation(connection) do
    time =  DateTime.now!("Etc/UTC") |> DateTime.to_unix()
    connection |> NetCommon.Connection.send(NetCommon.Message.create(NetCommon.Message.types(:validation), time))
  end

  def id(connection) do
    inspect connection
  end

  def socket(connection) do
    Agent.get(connection, &Map.get(&1, :socket))
  end

  def read_header(connection) do

    case :gen_tcp.recv(connection |> socket, 0) do
      {:ok, data} -> read_body(connection, data)
      _ -> nil # close socket
    end
  end

  def read_body(connection, data) do
    IO.inspect(data |> byte_size)

    header = data |> :erlang.binary_to_term()

    case :gen_tcp.recv(connection |> socket, header.size) do
      {:ok, data} -> add_to_incoming_message_queue(connection, data)
      _ -> nil # close socket
    end
  end

  def add_to_incoming_message_queue(connection, message) do
    Process.sleep 1000

    read_header(connection)
  end

  def send(connection, data) do
    header = EEx.eval_string("I<%= id %>S<%= size %>", id: data.header.id, size: data.header.size)

    :ok = :gen_tcp.send(connection |> socket, header |> :erlang.term_to_binary())
    :ok = :gen_tcp.send(connection |> socket, data |> :erlang.term_to_binary())
    :ok
  end
end