defmodule OS_Reductions do
  def count_reduction(data, fun) do
    caller = self()
    child = spawn(fn ->
      current = self()
      start = :os.timestamp()
      {_, r0} = Process.info(current, :reductions)
      _ = fun.(data)
      t = :timer.now_diff(:os.timestamp, start)
      {_, r1} = Process.info(current, :reductions)
      send(caller, {current, [time: t / 1_000_000, read_starting: r0, read_ending: r1, diff: r1 - r0]})
  end)

  receive do
    {^child, result} -> result
  end
  end
end

## Telemetry ?? s

## Look at Plug.Conn
