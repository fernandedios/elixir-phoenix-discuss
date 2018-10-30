defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    # IO.inspect conn
    # IO.inspect params

    # struct = %Discuss.Topic{}
    # params = %{}
    # changeset = Discuss.Topic.changeset(struct, params)

    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset  # plucked from templates/topic folder
  end

  # def create(conn, params) do
  # IO.inspect params

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      # {:ok, post} -> IO.inspect(post)
      # {:error, changeset} -> IO.inspect(changeset)

      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Created") # flash success message
        |> redirect(to: topic_path(conn, :index)) # redirect to index
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end

  end

end
