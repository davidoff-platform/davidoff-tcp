defmodule NetCommon.Message.Header do
  @enforce_keys [:id]
  defstruct [:id, size: 0]

  def size(header) do
    byte_size(Integer.to_string(header.id))
  end
end