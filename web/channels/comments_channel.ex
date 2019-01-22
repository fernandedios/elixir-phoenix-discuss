defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.Topic

  # "comments:" <> topic_id
  # pull id and assign as topic_id
  # topic_id is a string
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id) # convert to int
    topic = Repo.get(Topic, topic_id)

    {:ok, %{}, socket}
  end

  def handle_in(name, message, socket) do
    {:reply, :ok, socket}
  end
end
