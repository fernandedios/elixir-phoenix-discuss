defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.Topic

  # "comments:" <> topic_id
  # pull id and assign as topic_id
  # topic_id is a string
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id) # convert to int
    topic = Repo.get(Topic, topic_id)

    # assign topic inside socket
    {:ok, %{}, assign(socket, :topic, topic)}
  end

  # pattern matching to extract "content" from 2nd param
  def handle_in(name, %("content" => content), socket) do
    # extract topic from socket
    topic = socket.assigns.topic

    changeset = topic
      |> build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
