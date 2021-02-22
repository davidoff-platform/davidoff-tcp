defmodule NetCommon.Queue do
  use Agent

  def start_link(_queue) do
    Agent.start_link(fn -> [] end)
  end

  def front(queue) do
    Agent.get(queue, &List.first(&1))
  end

  def back(queue) do
    Agent.get(queue, &List.last(&1))
  end

  # push_back
  # push_front
  # count
  # empty
  # clear
  # pop_front - return and remove the first
  # pop_back  - return and remove the last

  # clear when destroying
end

