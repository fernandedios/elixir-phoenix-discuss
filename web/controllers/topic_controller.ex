defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  # plug with guard clause
  # only executes for the given routes in guard clause
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  # function plug
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    # failure to get, will show error thanks to get!
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
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
    # associate topic to user
    changeset = conn.assigns.user
    |> build_assoc(:topics) # returns a topic struct
    |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      # {:ok, topic} -> IO.inspect(topic)
      # {:error, changeset} -> IO.inspect(changeset)

      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created") # flash success message
        |> redirect(to: topic_path(conn, :index)) # redirect to index
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  # get id from params
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id) # get single record with id topic_id
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  # get id and topic from params
  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    # changeset = Repo.get(Topic, topic_id)
    # |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete! # ! bang explicitly geneerates an error if something goes wrong

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  # _params is NOT from form or router
  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    # fetch topic from db, compare user_id with logged in user's id
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn # return conn
    else
      conn
      |> put_flash(:error, "You cannot edit that") # display error
      |> redirect(to: topic_path(conn, :index)) # redirect to index
      |> halt() # stop further processing
    end
  end

end
