defmodule Discuss.UserSocket do
  use Phoenix.Socket

  channel "comments:*", Discuss.CommentsChannel
  transport :websocket, Phoenix.Transports.WebSocket

  # "token" is a string since it's from a json data
  def connect(%{"token" => token}, socket) do
    # IO.puts token
    case Phoenic.Token.verify(socket, "key", token) do # decode token
      # valid token
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
        
      # error decoding
      {:error, _error} ->
        :error
    end
    {:ok, socket}
  end

  def id(_socket), do: nil
end
