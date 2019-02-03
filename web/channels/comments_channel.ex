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
    user_id = socket.assigns.user_id

    changeset = topic
      # build assoc can't be called in succession, so associate user_id and comments in one go
      |> build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      # success
      {:ok, comment} ->
        # notify everyone subscribed
        # ! makes sure we're notified if something goes wrong
        # 2nd arg is the event name
        broadcast!(socket, "comments:#{socket.assogns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}

      # error
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
