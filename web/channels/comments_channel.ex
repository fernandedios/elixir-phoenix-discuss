defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.{Topic, Comment} # alias Topic and Comment

  # "comments:" <> topic_id
  # pull id and assign as topic_id
  # topic_id is a string
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id) # convert to int

    topic = Topic
      |> Repo.get(topic_id) # get topic using given topic_id
      |> Repo.preload(:comments) # get all comments associated with the topic

    # return comments, assign topic inside socket
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  # pattern matching to extract "content" from 2nd param
  def handle_in(name, %{"content" => content}, socket) do
    # extract topic from socket
    topic = socket.assigns.topic

    changeset = topic
      |> build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        {:reply, :ok, socket} # success
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket} # error
    end
  end
end
