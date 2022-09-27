defmodule HackerFun do
  use GenServer

  ## Pooling Strategies:
  ## 1. Checkout Pooling
  ## 2. Routing Pooling

  # Start the server
  def start_link() do
    GenServer.start_link(__MODULE__, {host_address, port})
  end

  # Client API
  def handle_request(server, request) do
    GenServer.call(server, {:request, request})
  end

  # Server API
  @impl true
  def init({host_address, port}) do
    case :gen_tcp(host_address, port, []) do
      # Requests are a map of request IDs
      {:ok, socket} -> {:ok, {socket, _requests = %{}}}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl true
  def handle_call({:request, request}, from, {socket, requests}) do
    # request ID
    id = create_id()

    # Pass serialized data packet to socket
    :ok = :gen_tcp.send(socket, Jason.encode_to_iodata!({id, request}))

    # @spec from() :: {pid(), tag :: term()} -> tag is a unique term used
    # to identify the call.
    # Store the "from" under the request ID so we'll know who to reply to
    {:noreply, Map.put(requests, id, from)}
  end

  @impl true
  def handle_info({:tcp, socket, data}, {socket, requests}) do
    # Serialize response
    {id, response} = Jason.decode!(data)
    {from, requests} = Map.pop!(requests, id)

    GenServer.reply(from, {:ok, response})
    {:noreply, {socket, requests}}
  end

  # Add a registry for processes and nodes
end
